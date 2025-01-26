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
//            case deferred(([UIMenuElement]) -> ())
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: ChidoriMenu.MenuContent, rhs: ChidoriMenu.MenuContent) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
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
    typealias DataSource = UITableViewDiffableDataSource<MenuSection, MenuContent>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MenuSection, MenuContent>

    func updateSnapshot() {
        var snapshot = Snapshot()
        let contents = flatMap(menu: menu)
        for (section, items) in contents {
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func flatMap(menu: UIMenu) -> [(MenuSection, [MenuContent])] {
        flatMap(initialTitle: menu.title, menuChildren: menu.children)
    }

    func flatMap(initialTitle: String = "", menuChildren: [UIMenuElement]) -> [(MenuSection, [MenuContent])] {
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
            if let childMenu = element as? UIMenu {
                if childMenu.options.contains(.displayInline) {
                    sectionBuilderCommit()
                    for (section, items) in flatMap(menu: childMenu) {
                        result.append((section, items))
                    }
                    continue
                }
                sectionBuilder.append(.init(content: .submenu(childMenu)))
                continue
            }
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
            assertionFailure()
        }
        sectionBuilderCommit()

        return result
    }

    func executeAction(_ indexPath: IndexPath) {
        guard let action = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let content = action.content
        switch content {
        case let .action(action):
            action.execute()
            presentingParent?.dismiss(animated: true)
        case let .submenu(menu):
            cell.present(menu: menu, anchorPoint: .init(
                x: cell.convert(cell.bounds, to: cell.window ?? .init()).midX,
                y: cell.convert(.zero, to: cell.window ?? .init()).minY - ChidoriMenu.offsetY
            ))
            iterateMenusInStack {
                $0.menuStackScaleFactor *= 1 - ChidoriMenu.stackScaleFactor
            }
        }
    }
}
