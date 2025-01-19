//
//  ChidoriMenu+Cell.swift
//  Chidori
//
//  Created by Christian Selig on 2021-02-16.
//

import UIKit

extension ChidoriMenu {
    class Cell: UITableViewCell {
        var menuTitle: String = "" {
            didSet { menuTitleLabel.text = menuTitle }
        }

        var isDestructive: Bool = false {
            didSet {
                let color: UIColor = isDestructive ? .systemRed : .label
                menuTitleLabel.textColor = color
                iconImageView.tintColor = color
            }
        }

        var iconImage: UIImage? {
            didSet { iconImageView.image = iconImage }
        }

        override var accessibilityHint: String? {
            get { super.accessibilityHint ?? menuTitle }
            set { super.accessibilityHint = newValue }
        }

        private let stackView: UIStackView = .init()
        private let menuTitleLabel: UILabel = .init()
        private let iconImageView: UIImageView = .init()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .clear
            selectionStyle = .none
            accessibilityTraits = [.button]

            preservesSuperviewLayoutMargins = false
            separatorInset = UIEdgeInsets.zero
            layoutMargins = UIEdgeInsets.zero

            menuTitleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
            menuTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            menuTitleLabel.numberOfLines = 0
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(menuTitleLabel)
            contentView.addSubview(iconImageView)

            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(
                    equalTo: menuTitleLabel.leadingAnchor,
                    constant: -Self.horizontalPadding
                ),
                contentView.topAnchor.constraint(
                    equalTo: menuTitleLabel.topAnchor,
                    constant: -Self.verticalPadding
                ),
                contentView.bottomAnchor.constraint(
                    equalTo: menuTitleLabel.bottomAnchor,
                    constant: Self.verticalPadding
                ),
                menuTitleLabel.trailingAnchor.constraint(
                    equalTo: iconImageView.leadingAnchor,
                    constant: Self.titleToIconMinSpacing
                ),
                contentView.trailingAnchor.constraint(
                    equalTo: iconImageView.centerXAnchor,
                    constant: Self.iconTrailingOffset
                ),
                contentView.centerYAnchor.constraint(
                    equalTo: iconImageView.centerYAnchor
                ),
            ])
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) { fatalError("\(#file) does not implement coder.") }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            backgroundColor = selected ? Self.darkColor : .clear
        }

        override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            super.setSelected(highlighted, animated: animated)
            backgroundColor = highlighted ? Self.darkColor : .clear
        }
    }

    class HeaderCell: UIView {
        let titleLabel: UILabel = .init()

        init() {
            super.init(frame: .zero)

            titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            titleLabel.numberOfLines = 1
            titleLabel.textColor = .secondaryLabel
            titleLabel.textAlignment = .left
            addSubview(titleLabel)

            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: ChidoriMenu.Cell.horizontalPadding
                ),
                titleLabel.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -ChidoriMenu.Cell.horizontalPadding
                ),
                titleLabel.centerYAnchor.constraint(
                    equalTo: centerYAnchor,
                    constant: -ChidoriMenu.sectionTopPadding / 2
                ),
            ])
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError()
        }
    }
}
