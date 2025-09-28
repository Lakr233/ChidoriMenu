//
//  ChidoriMenu+DataSource.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import Foundation
import UIKit

extension ChidoriMenu {
    struct MenuSection: Identifiable, Hashable {
        let id = UUID()
        let title: String
    }

    struct MenuContent: Identifiable, Hashable {
        let id = UUID()
        let content: Content
        enum Content {
            case action(UIAction)
            case submenu(UIMenu)
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: ChidoriMenu.MenuContent, rhs: ChidoriMenu.MenuContent) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
    }
}

// Helper extensions for attribute handling
extension UIAction {
    var chidoriIsDisabled: Bool {
        attributes.contains(.disabled)
    }

    var chidoriKeepsMenuPresented: Bool {
        if #available(iOS 16.0, macCatalyst 16.0, *) {
            attributes.contains(.keepsMenuPresented)
        } else {
            false
        }
    }
}

extension UIMenu {
    var chidoriIsDisabled: Bool {
        // UIMenu.Options doesn't have .disabled, so we need to check individual menu elements
        // For submenus, we'll check if all children are disabled or if the menu itself has disabled state
        false // Submenus don't have a direct disabled attribute in UIMenu.Options
    }
}

extension ChidoriMenu.MenuContent {
    var description: String {
        switch content {
        case let .action(action):
            "action: \(action.title)"
        case let .submenu(menu):
            "submenu: \(menu.title)"
        }
    }
}

extension ChidoriMenu {
    typealias DataSourceContents = [(section: MenuSection, contents: [MenuContent])]

    func updateDataSourceContents() {
        assert(Thread.isMainThread)
        let contents = flatMap(menu: menu)
        dataSource = contents
        tableView.reloadData()
    }

    func flatMap(menu: UIMenu) -> DataSourceContents {
        if let menu = menu as? DeferredMenu {
            return flatMap(menu: menu.menuProvider())
        }
        return flatMap(initialTitle: menu.title, menuChildren: menu.children)
    }

    func flatMap(initialTitle: String = "", menuChildren: [UIMenuElement]) -> DataSourceContents {
        var result: [(MenuSection, [MenuContent])] = []

        var sectionTitle: String = initialTitle
        var sectionBuilder: [MenuContent] = []

        let sectionBuilderCommit = {
            defer { sectionTitle = "" }
            defer { sectionBuilder = [] }
            guard !sectionBuilder.isEmpty else { return }
            let section = MenuSection(title: sectionTitle)
            result.append((section, sectionBuilder))
        }

        for element in menuChildren {
            if let action = element as? UIAction {
                sectionBuilder.append(.init(content: .action(action)))
                continue
            }

            // MARK: - UIMenu & DeferredMenu(Backport iOS 14+)

            var childMenu: UIMenu?
            if let castMenu = element as? DeferredMenu {
                childMenu = castMenu.menuProvider()
            } else if let castMenu = element as? UIMenu {
                childMenu = castMenu
            }
            if let childMenu {
                if childMenu.options.contains(.displayInline) {
                    let title = childMenu.title
                    if title.isEmpty {
                        var firstSectionAppended = false
                        for (section, items) in flatMap(menu: childMenu) {
                            if firstSectionAppended {
                                result.append((section, items))
                            } else {
                                sectionBuilder.append(contentsOf: items)
                                firstSectionAppended = true
                                sectionBuilderCommit()
                            }
                        }
                    } else {
                        sectionBuilderCommit()
                        for (section, items) in flatMap(menu: childMenu) {
                            result.append((section, items))
                        }
                    }
                    continue
                }
                sectionBuilder.append(.init(content: .submenu(childMenu)))
                continue
            }

            // MARK: - UIDeferredMenuElement

            if #available(iOS 14.0, macCatalyst 14.0, *) {
                if let deferred = element as? UIDeferredMenuElement {
                    var menuItems: [UIMenuElement] = []
                    var menuItemsWasSet = false
                    let retriever = { (items: [UIMenuElement]) in
                        menuItemsWasSet = true
                        menuItems = items
                    }
                    let selector = NSSelectorFromString("elementProvider")
                    guard deferred.responds(to: selector),
                          let block = deferred.perform(selector)?.takeUnretainedValue()
                    else {
                        assertionFailure()
                        continue
                    }
                    typealias ProviderBlock = @convention(block) (([UIMenuElement]) -> Void) -> Void
                    let providerBlock = unsafeBitCast(block, to: ProviderBlock.self)
                    providerBlock(retriever)
                    assert(menuItemsWasSet, "ChidoriMenu does not support async deferred menu elements")
                    guard !menuItems.isEmpty else { continue }

                    sectionBuilderCommit()
                    for (section, items) in flatMap(menuChildren: menuItems) {
                        result.append((section, items))
                    }
                    continue
                }
            }
            assertionFailure()
        }
        sectionBuilderCommit()

        return result
    }

    func executeAction(_ indexPath: IndexPath) {
        guard let action = item(forIndexPath: indexPath) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        // Check if action is disabled
        switch action.content {
        case let .action(action):
            if action.chidoriIsDisabled {
                return
            }
        case let .submenu(menu):
            if menu.chidoriIsDisabled {
                return
            }
        }

        if let haptic = ChidoriMenuConfiguration.hapticFeedback {
            UIImpactFeedbackGenerator(style: haptic).impactOccurred()
        }

        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        let content = action.content
        switch content {
        case let .action(action):
            guard view.isUserInteractionEnabled else {
                assertionFailure()
                return
            }
            view.isUserInteractionEnabled = false

            // Check if we should keep menu presented
            if action.chidoriKeepsMenuPresented {
                action.execute()
                view.isUserInteractionEnabled = true
                // Reload table view to reflect any state changes
                tableView.reloadData()
            } else {
                presentingParent?.dismiss(animated: true) {
                    action.execute()
                }
                #if DEBUG
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        assert(self == nil)
                    }
                #endif
            }
        case let .submenu(menu):
            cell.present(menu: menu, anchorPoint: .init(
                x: cell.bounds.midX,
                y: cell.bounds.minY - ChidoriMenu.offsetY
            ))
            iterateMenusInStack {
                $0.menuStackScaleFactor -= ChidoriMenu.stackScaleFactor
            }
        }
    }
}
