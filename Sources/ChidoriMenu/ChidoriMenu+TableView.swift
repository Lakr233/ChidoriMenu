//
//  ChidoriMenu+TableView.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

extension ChidoriMenu: UITableViewDelegate {
    typealias DataSource = UITableViewDiffableDataSource<UIMenu, UIAction>
    static func createDataSource(tableView: UITableView) -> DataSource {
        let dataSource = UITableViewDiffableDataSource<UIMenu, UIAction>(
            tableView: tableView
        ) { tableView, indexPath, action -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: Cell.self),
                for: indexPath
            ) as! Cell
            cell.menuTitle = action.title
            cell.iconImage = action.image
            cell.isDestructive = action.attributes.contains(.destructive)
            return cell
        }
        return dataSource
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section != tableView.numberOfSections - 1 else { return nil }

        let footerView = UIView()
        footerView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionDividerHeight: CGFloat = 8.0

        // If it's the last section, don't show a divider, otherwise do
        return section == tableView.numberOfSections - 1 ? 0.0 : sectionDividerHeight
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        executeAction(indexPath)
        dismiss(animated: true)
    }
}
