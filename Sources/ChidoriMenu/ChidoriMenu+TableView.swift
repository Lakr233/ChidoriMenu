//
//  ChidoriMenu+TableView.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

extension ChidoriMenu: UITableViewDelegate {
    func cell(forRowAtIndex indexPath: IndexPath, dataSource: DataSource) -> UITableViewCell? {
        guard let section = dataSource.sectionIdentifier(for: indexPath.section),
              let item = dataSource.itemIdentifier(for: indexPath)
        else { return nil }
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: Cell.self),
            for: indexPath
        ) as! Cell
        switch item.content {
        case let .action(action):
            cell.menuTitle = action.title
            cell.iconImage = action.image
            cell.isDestructive = action.attributes.contains(.destructive)
            switch action.state {
            case .on: cell.trailingItem = .checkmark
            case .mixed: cell.trailingItem = .detailButton
            default: cell.trailingItem = .none
            }
            cell.trailingIconView.tintColor = .label
        case let .submenu(menu):
            cell.menuTitle = menu.title
            cell.iconImage = menu.image
            cell.isDestructive = false
            cell.trailingItem = .disclosureIndicator
            cell.trailingIconView.tintColor = .label
        }
        if section.title.isEmpty, indexPath.row == 0, indexPath.section == 0 {
            cell.topSep.isHidden = true
        } else {
            cell.topSep.isHidden = false
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == tableView.numberOfSections - 1 { return nil }
        let footerView = UIView(frame: .zero)
        footerView.backgroundColor = ChidoriMenu.dimmingSectionSepratorColor
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 { return 0 }
        return ChidoriMenu.dimmingSectionSepratorHeight
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        executeAction(indexPath)
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = dataSource.sectionIdentifier(for: section) else {
            return 0
        }
        if section.title.isEmpty { return 0 }
        return UIFont.preferredFont(forTextStyle: .footnote).lineHeight + 8
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = dataSource.sectionIdentifier(for: section) else {
            return nil
        }
        if section.title.isEmpty { return nil }
        let cell = HeaderCell()
        cell.titleLabel.text = section.title
        return cell
    }
}
