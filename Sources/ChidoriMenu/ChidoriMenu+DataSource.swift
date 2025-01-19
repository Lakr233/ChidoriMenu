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

extension ChidoriMenu {
    typealias DataSource = UITableViewDiffableDataSource<MenuSection, MenuContent>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MenuSection, MenuContent>

    func updateSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot = flatMap(snapshot: snapshot, menu: menu)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func flatMap(snapshot: Snapshot, menu: UIMenu) -> Snapshot {
        var snapshot = snapshot // mutable copy

        var sectionTitle: String = menu.title
        var sectionBuilder: [MenuContent] = []

        let sectionBuilderCommit = {
            defer { sectionTitle = "" } // clear
            guard !sectionBuilder.isEmpty else { return }
            let section = MenuSection(title: sectionTitle)
            snapshot.appendSections([section])
            snapshot.appendItems(sectionBuilder, toSection: section)
        }

        for element in menu.children {
            if let action = element as? UIAction {
                sectionBuilder.append(.init(content: .action(action)))
                continue
            }
            if let childMenu = element as? UIMenu {
                if childMenu.options.contains(.displayInline) {
                    snapshot = flatMap(snapshot: snapshot, menu: childMenu)
                    continue
                }
                sectionBuilder.append(.init(content: .submenu(childMenu)))
                continue
            }
            if let deferred = element as? UIDeferredMenuElement {
                // TODO: IMPL
                assertionFailure("current \(deferred) unsupported")
            }
            assertionFailure("unknown menu element")
        }
        sectionBuilderCommit()

        return snapshot
    }

    func executeAction(_ indexPath: IndexPath) {
        guard let action = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        let content = action.content
        switch content {
        case let .action(action):
            action.execute()
            dismiss(animated: true)
        case let .submenu(menu):
            var summonPoint: CGPoint?
            if let window = cell.window {
                let boundsCenter: CGPoint = .init(
                    x: cell.bounds.minX,
                    y: cell.bounds.midY
                )
                summonPoint = cell.convert(boundsCenter, to: window)
            }
            cell.present(menu: menu, summonPoint: summonPoint)
        }
    }

    static func createDataSource(tableView: UITableView) -> DataSource {
        let dataSource = DataSource(
            tableView: tableView
        ) { tableView, indexPath, item -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: Cell.self),
                for: indexPath
            ) as! Cell
            switch item.content {
            case let .action(action):
                cell.menuTitle = action.title
                cell.iconImage = action.image
                cell.isDestructive = action.attributes.contains(.destructive)
                cell.accessoryType = .none
                cell.accessoryView?.tintColor = .label
            case let .submenu(menu):
                cell.menuTitle = menu.title
                cell.iconImage = menu.image
                cell.isDestructive = false
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView?.tintColor = .label
            }
            return cell
        }
        return dataSource
    }
}
