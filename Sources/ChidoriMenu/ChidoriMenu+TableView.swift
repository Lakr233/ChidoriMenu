//
//  ChidoriMenu+TableView.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

extension ChidoriMenu: UITableViewDelegate, UITableViewDataSource {
    func section(at indexPath: IndexPath) -> MenuSection? {
        section(at: indexPath.section)
    }

    func section(at index: Int) -> MenuSection? {
        dataSource[index].section
    }

    func item(at indexPath: IndexPath) -> MenuContent? {
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
        guard let section = section(at: indexPath),
              let item = item(at: indexPath)
        else { return nil }
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: Cell.self),
            for: indexPath
        ) as! Cell
        cell.hasAnyIcon = hasAnyIcon
        switch item.content {
        case let .action(action):
            cell.title = action.title
            cell.icon = action.image
            cell.isDestructive = action.attributes.contains(.destructive)
            cell.isDisabled = action.chidoriIsDisabled
            switch action.state {
            case .on: cell.trailingAccessory = .checkmark
            case .mixed: cell.trailingAccessory = .detailButton
            default: cell.trailingAccessory = .none
            }
            cell.trailingIconView.tintColor = .label
        case let .submenu(menu):
            cell.title = menu.title
            cell.icon = menu.image
            cell.isDestructive = menu.options.contains(.destructive)
            cell.isDisabled = menu.chidoriIsDisabled
            cell.trailingAccessory = .disclosureIndicator
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
        guard let action = item(at: indexPath) else { return }

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

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = item(at: indexPath) else {
            return UITableView.automaticDimension
        }

        let menuWidth = width
        var availableTextWidth = menuWidth - MenuLayout.horizontalPadding * 2

        // Use consistent text alignment when any menu item has an icon
        if hasAnyIcon {
            // All text aligned after icon space when any item has an icon
            availableTextWidth -= ChidoriMenu.iconSize + ChidoriMenu.spacing
        }

        switch item.content {
        case let .action(action):
            // Subtract icon space if present (unless already accounted for)
            if action.image != nil && !hasAnyIcon {
                availableTextWidth -= ChidoriMenu.iconSize + ChidoriMenu.spacing
            }
            // Subtract trailing icon space if present
            if action.chidoriKeepsMenuPresented || action.state != .off {
                availableTextWidth -= ChidoriMenu.iconSize + ChidoriMenu.spacing
            }

        case let .submenu(menu):
            // Subtract icon space if present (unless already accounted for)
            if menu.image != nil, !hasAnyIcon {
                availableTextWidth -= ChidoriMenu.iconSize + ChidoriMenu.spacing
            }
            // Always subtract trailing icon for submenus
            availableTextWidth -= ChidoriMenu.iconSize + ChidoriMenu.spacing
        }

        // Calculate text height
        let font = UIFont.preferredFont(forTextStyle: .body)
        let textHeight = (item.title as NSString).boundingRect(
            with: CGSize(width: availableTextWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        ).height

        let rowHeight = max(textHeight + ChidoriMenu.verticalPadding * 2, ChidoriMenu.minRowHeight)
        return rowHeight
    }

    func tableView(_: UITableView, heightForHeaderInSection sectionIndex: Int) -> CGFloat {
        guard let section = section(at: sectionIndex) else {
            return 0
        }
        if section.title.isEmpty { return 0 }
        return UIFont.preferredFont(forTextStyle: .footnote).lineHeight + 8
    }

    func tableView(_: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView? {
        guard let section = section(at: sectionIndex) else {
            return nil
        }
        if section.title.isEmpty { return nil }
        let cell = HeaderCell()
        cell.titleLabel.text = section.title
        return cell
    }
}
