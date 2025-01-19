//
//  ChidoriMenu+TableView.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

extension ChidoriMenu: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == tableView.numberOfSections - 1 { return nil }
        let footerView = UIView(frame: .zero)
        footerView.backgroundColor = ChidoriMenu.dimmingSectionSepratorColor
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 { return 0 }
        return 8
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
