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

        var title: String {
            switch content {
            case let .action(action):
                action.title
            case let .submenu(menu):
                menu.title
            }
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

    func updateDataSource() {
        assert(Thread.isMainThread)
        let contents = flattenedContents(from: menu)
        dataSource = contents
        hasAnyIcon = calculateHasAnyIcon()
        tableView.reloadData()
    }

    private func calculateHasAnyIcon() -> Bool {
        for section in dataSource {
            for content in section.contents {
                switch content.content {
                case let .action(action):
                    if action.image != nil {
                        return true
                    }
                case let .submenu(menu):
                    if menu.image != nil {
                        return true
                    }
                }
            }
        }
        return false
    }

    func flattenedContents(from menu: UIMenu) -> DataSourceContents {
        if let menu = menu as? DeferredMenu {
            return flattenedContents(from: menu.menuProvider())
        }
        return flattenedContents(initialTitle: menu.title, menuChildren: menu.children)
    }

    func flattenedContents(initialTitle: String = "", menuChildren: [UIMenuElement]) -> DataSourceContents {
        var result: [(MenuSection, [MenuContent])] = []

        var sectionTitle: String = initialTitle
        var sectionBuilder: [MenuContent] = []
        var shouldSubmitSection = false

        func commitCurrentSection() {
            guard !sectionBuilder.isEmpty else { return }
            let section = MenuSection(title: sectionTitle)
            result.append((section, sectionBuilder))
            sectionTitle = ""
            sectionBuilder = []
        }

        for element in menuChildren {
            if processUIAction(
                element,
                sectionBuilder: &sectionBuilder
            ) { continue }
            if processUIMenu(
                element,
                sectionBuilder: &sectionBuilder,
                result: &result,
                commitSection: { shouldSubmitSection = true }
            ) { continue }
            if processUIDeferredMenuElement(
                element,
                commitSection: { shouldSubmitSection = true },
                result: &result
            ) { continue }
            assertionFailure()
        }

        if shouldSubmitSection {
            commitCurrentSection()
        }

        return result
    }

    private func processUIAction(_ element: UIMenuElement, sectionBuilder: inout [MenuContent]) -> Bool {
        guard let action = element as? UIAction else { return false }
        sectionBuilder.append(.init(content: .action(action)))
        return true
    }

    private func processUIMenu(
        _ element: UIMenuElement,
        sectionBuilder: inout [MenuContent],
        result: inout [(MenuSection, [MenuContent])],
        commitSection: () -> Void
    ) -> Bool {
        var childMenu: UIMenu?
        if let castMenu = element as? DeferredMenu {
            childMenu = castMenu.menuProvider()
        } else if let castMenu = element as? UIMenu {
            childMenu = castMenu
        }
        guard let childMenu else { return false }

        if childMenu.options.contains(.displayInline) {
            processInlineMenu(childMenu, sectionBuilder: &sectionBuilder, result: &result, commitSection: commitSection)
        } else {
            sectionBuilder.append(.init(content: .submenu(childMenu)))
        }
        return true
    }

    private func processInlineMenu(
        _ menu: UIMenu,
        sectionBuilder: inout [MenuContent],
        result: inout [(MenuSection, [MenuContent])],
        commitSection: () -> Void
    ) {
        let title = menu.title
        if title.isEmpty {
            var firstSectionAppended = false
            for (section, items) in flattenedContents(from: menu) {
                if firstSectionAppended {
                    result.append((section, items))
                } else {
                    sectionBuilder.append(contentsOf: items)
                    firstSectionAppended = true
                    commitSection()
                }
            }
        } else {
            commitSection()
            for (section, items) in flattenedContents(from: menu) {
                result.append((section, items))
            }
        }
    }

    private func processUIDeferredMenuElement(
        _ element: UIMenuElement,
        commitSection: () -> Void,
        result: inout [(MenuSection, [MenuContent])]
    ) -> Bool {
        guard #available(iOS 14.0, macCatalyst 14.0, *) else { return false }
        guard let deferred = element as? UIDeferredMenuElement else { return false }

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
            return true
        }
        typealias ProviderBlock = @convention(block) (([UIMenuElement]) -> Void) -> Void
        let providerBlock = unsafeBitCast(block, to: ProviderBlock.self)
        providerBlock(retriever)
        assert(menuItemsWasSet, "ChidoriMenu does not support async deferred menu elements")
        guard !menuItems.isEmpty else { return true }

        commitSection()
        for (section, items) in flattenedContents(menuChildren: menuItems) {
            result.append((section, items))
        }
        return true
    }

    func executeAction(_ indexPath: IndexPath) {
        guard let action = item(at: indexPath) else { return }
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
            forEachMenuInStack {
                $0.menuStackScaleFactor -= ChidoriMenu.stackScaleFactor
            }
        }
    }
}
