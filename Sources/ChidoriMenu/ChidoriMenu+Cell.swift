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
            didSet { textLabel?.text = menuTitle }
        }

        var isDestructive: Bool = false {
            didSet {
                let color: UIColor = isDestructive ? .systemRed : .label
                textLabel?.textColor = color
                imageView?.tintColor = color
            }
        }

        var iconImage: UIImage? {
            didSet { imageView?.image = iconImage }
        }

        override var accessibilityHint: String? {
            get { super.accessibilityHint ?? menuTitle }
            set { super.accessibilityHint = newValue }
        }

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .clear
            selectionStyle = .none
            accessibilityTraits = [.button]
            textLabel?.textColor = .label
            imageView?.contentMode = .scaleAspectFit
            imageView?.tintColor = .label
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) { fatalError("\(#file) does not implement coder.") }

        override func layoutSubviews() {
            super.layoutSubviews()
            removeInsetOnSeparator()
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            removeInsetOnSeparator()
        }

        func removeInsetOnSeparator() {
            preservesSuperviewLayoutMargins = false
            separatorInset = UIEdgeInsets.zero
            layoutMargins = UIEdgeInsets.zero
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            backgroundColor = selected ? Self.highlightCoverColor : .clear
        }

        override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            super.setSelected(highlighted, animated: animated)
            backgroundColor = highlighted ? Self.highlightCoverColor : .clear
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

        override func layoutSubviews() {
            super.layoutSubviews()
        }
    }
}
