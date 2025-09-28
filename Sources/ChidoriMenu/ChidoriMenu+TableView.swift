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
        cell.sectionHasAnyIcon = section.hasAnyIcon
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

        executeAction(indexPath, touchLocation: nil) // TODO: Better touch location
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = item(at: indexPath),
              let section = section(at: indexPath)
        else {
            return UITableView.automaticDimension
        }

        let menuWidth = width

        let titleX: CGFloat = if section.hasAnyIcon {
            MenuLayout.horizontalPadding + MenuLayout.iconSize + MenuLayout.spacing
        } else {
            MenuLayout.horizontalPadding
        }

        let trailingIconSpace: CGFloat = switch item.content {
        case let .action(action):
            action.state != .off ? MenuLayout.iconSize + MenuLayout.spacing : 0
        case .submenu:
            MenuLayout.iconSize + MenuLayout.spacing
        }

        let availableTextWidth = menuWidth - titleX - MenuLayout.horizontalPadding - trailingIconSpace

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

    func updateMenuContainerFrame() {
        tableView.layoutIfNeeded()

        let measuredHeight = tableView.contentSize.height.rounded(.up)
        let menuWidth = width

        let applySize: (CGSize) -> Void = { size in
            self.view.bounds.size = size
            self.view.frame.size = size
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }

        guard let controller = presentationController as? ChidoriPresentationController else {
            applySize(.init(width: menuWidth, height: measuredHeight))
            return
        }

        guard let containerView = controller.containerView else {
            applySize(.init(width: menuWidth, height: measuredHeight))
            return
        }

        let safeArea = containerView.safeAreaInsets
        let maximumHeight = max(
            MenuLayout.minRowHeight,
            containerView.bounds.height
                - controller.minimalEdgeInset * 2
                - safeArea.top
                - safeArea.bottom
        )
        let clampedHeight = min(measuredHeight, maximumHeight)

        applySize(.init(width: menuWidth, height: clampedHeight))

        let newFrame = controller.frameOfPresentedViewInContainerView
        view.frame = newFrame
        controller.presentedView?.frame = newFrame
        anchor(to: newFrame)

        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
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
