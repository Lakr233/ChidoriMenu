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

        let sep = UIView()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .clear
            selectionStyle = .none
            accessibilityTraits = [.button]
            textLabel?.textColor = .label
            imageView?.contentMode = .scaleAspectFit
            imageView?.tintColor = .label
            accessoryView?.isUserInteractionEnabled = false
            preservesSuperviewLayoutMargins = false
            separatorInset = UIEdgeInsets.zero
            layoutMargins = UIEdgeInsets.zero
            sep.backgroundColor = ChidoriMenu.dimmingSectionSepratorColor
            textLabel?.numberOfLines = 0
            contentView.addSubview(sep)

            if let imageView { // just in case
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                    imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    imageView.heightAnchor.constraint(equalToConstant: 20),
                    // 44 - left 8 - right 8 = 28
                    imageView.widthAnchor.constraint(equalToConstant: 28),
                ])
            }
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) { fatalError() }

        override func layoutSubviews() {
            super.layoutSubviews()
            sep.frame = .init(
                x: 0,
                y: 0,
                width: bounds.width,
                height: 1
            )
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
                    constant: 8
                ),
                titleLabel.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -8
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
