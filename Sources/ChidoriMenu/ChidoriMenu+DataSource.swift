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
        let hasAnyIcon: Bool
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

    private func debugAssertMenuDeallocated() {
        #if DEBUG
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                assert(self == nil)
            }
        #endif
    }

    private class MenuFlatteningContext {
        var result: [(MenuSection, [MenuContent])] = []
        var sectionTitle: String
        var sectionBuilder: [MenuContent] = []
        init(initialTitle: String = "") {
            sectionTitle = initialTitle
        }

        func commitCurrentSection() {
            guard !sectionBuilder.isEmpty else { return }

            // Calculate if this section has any icons
            let sectionHasAnyIcon = sectionBuilder.contains { content in
                switch content.content {
                case let .action(action):
                    action.image != nil
                case let .submenu(menu):
                    menu.image != nil
                }
            }

            let section = MenuSection(title: sectionTitle, hasAnyIcon: sectionHasAnyIcon)
            result.append((section, sectionBuilder))
            sectionTitle = ""
            sectionBuilder = []
        }
    }

    func updateDataSource() {
        assert(Thread.isMainThread)
        let contents = flattenedContents(from: menu)
        dataSource = contents
        tableView.reloadData()
    }

    func flattenedContents(from menu: UIMenu) -> DataSourceContents {
        if let menu = menu as? DeferredMenu {
            return flattenedContents(from: menu.menuProvider())
        }
        return flattenedContents(initialTitle: menu.title, menuChildren: menu.children)
    }

    func flattenedContents(initialTitle: String = "", menuChildren: [UIMenuElement]) -> DataSourceContents {
        let context = MenuFlatteningContext(initialTitle: initialTitle)

        for element in menuChildren {
            if processUIAction(element, context: context) { continue }
            if processUIMenu(element, context: context) { continue }
            if processUIDeferredMenuElement(element, context: context) { continue }
            assertionFailure()
        }

        if !context.sectionBuilder.isEmpty {
            // Commit any remaining items in the section builder
            context.commitCurrentSection()
        }

        return context.result
    }

    private func processUIAction(_ element: UIMenuElement, context: MenuFlatteningContext) -> Bool {
        guard let action = element as? UIAction else { return false }
        context.sectionBuilder.append(.init(content: .action(action)))
        return true
    }

    private func processUIMenu(_ element: UIMenuElement, context: MenuFlatteningContext) -> Bool {
        var childMenu: UIMenu?
        if let castMenu = element as? DeferredMenu {
            childMenu = castMenu.menuProvider()
        } else if let castMenu = element as? UIMenu {
            childMenu = castMenu
        }
        guard let childMenu else { return false }

        if childMenu.options.contains(.displayInline) {
            processInlineMenu(childMenu, context: context)
        } else {
            context.sectionBuilder.append(.init(content: .submenu(childMenu)))
        }
        return true
    }

    private func processInlineMenu(_ menu: UIMenu, context: MenuFlatteningContext) {
        let title = menu.title
        if title.isEmpty {
            var firstSectionAppended = false
            for (section, items) in flattenedContents(from: menu) {
                if firstSectionAppended {
                    context.result.append((section, items))
                } else {
                    context.sectionBuilder.append(contentsOf: items)
                    firstSectionAppended = true
                    context.commitCurrentSection()
                }
            }
        } else {
            context.commitCurrentSection()
            for (section, items) in flattenedContents(from: menu) {
                context.result.append((section, items))
            }
        }
    }

    private func processUIDeferredMenuElement(_ element: UIMenuElement, context: MenuFlatteningContext) -> Bool {
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

        context.commitCurrentSection()
        for (section, items) in flattenedContents(menuChildren: menuItems) {
            context.result.append((section, items))
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
                debugAssertMenuDeallocated()
            }
        case let .submenu(menu):
            cell.present(menu: menu, anchorPoint: .init(
                x: cell.bounds.midX,
                y: cell.bounds.minY - MenuLayout.offsetY
            ))
            forEachMenuInStack {
                $0.menuStackScaleFactor -= MenuLayout.stackScaleFactor
            }
        }
    }
}
