//
//  ChidoriMenu+TableView.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

extension ChidoriMenu: UITableViewDelegate, UITableViewDataSource {
    func sectionContents(forIndexPath indexPath: IndexPath) -> MenuSection? {
        sectionContents(for: indexPath.section)
    }

    func sectionContents(for sectionIndex: Int) -> MenuSection? {
        dataSource[sectionIndex].section
    }

    func item(forIndexPath indexPath: IndexPath) -> MenuContent? {
        dataSource[indexPath.section].contents[indexPath.row]
    }

    func numberOfSections(in _: UITableView) -> Int {
        dataSource.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].contents.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell(forRowAtIndex: indexPath, dataSource: dataSource) ?? UITableViewCell()
    }

    func cell(forRowAtIndex indexPath: IndexPath, dataSource _: DataSourceContents) -> UITableViewCell? {
        guard let section = sectionContents(forIndexPath: indexPath),
              let item = item(forIndexPath: indexPath)
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
            cell.isDisabled = action.chidoriIsDisabled
            switch action.state {
            case .on: cell.trailingItem = .checkmark
            case .mixed: cell.trailingItem = .detailButton
            default: cell.trailingItem = .none
            }
            cell.trailingIconView.tintColor = .label
        case let .submenu(menu):
            cell.menuTitle = menu.title
            cell.iconImage = menu.image
            cell.isDestructive = menu.options.contains(.destructive)
            cell.isDisabled = menu.chidoriIsDisabled
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let action = item(forIndexPath: indexPath) else { return }

        // Check if action is disabled
        switch action.content {
        case let .action(action):
            if action.chidoriIsDisabled {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
        case let .submenu(menu):
            if menu.chidoriIsDisabled {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
        }

        executeAction(indexPath)
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = sectionContents(for: section) else {
            return 0
        }
        if section.title.isEmpty { return 0 }
        return UIFont.preferredFont(forTextStyle: .footnote).lineHeight + 8
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = sectionContents(for: section) else {
            return nil
        }
        if section.title.isEmpty { return nil }
        let cell = HeaderCell()
        cell.titleLabel.text = section.title
        return cell
    }
}
