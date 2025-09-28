//
//  ChidoriMenu+Cell.swift
//  Chidori
//
//  Created by Christian Selig on 2021-02-16.
//

import UIKit

extension ChidoriMenu {
    class Cell: UITableViewCell {
        var title: String = "" {
            didSet {
                titleLabel.text = title
                layoutIfNeeded()
            }
        }

        var isDestructive: Bool = false {
            didSet {
                let color: UIColor = isDestructive ? .systemRed : .label
                titleLabel.textColor = color
                iconView.tintColor = color
            }
        }

        var isDisabled: Bool = false {
            didSet {
                let alpha: CGFloat = isDisabled ? 0.3 : 1.0
                contentView.alpha = alpha
            }
        }

        var icon: UIImage? {
            didSet {
                iconView.image = icon
                iconView.isHidden = icon == nil
            }
        }

        var trailingAccessory: UITableViewCell.AccessoryType = .none {
            didSet {
                switch trailingAccessory {
                case .disclosureIndicator:
                    trailingIconView.image = UIImage(systemName: "chevron.right")?
                        .withTintColor(.gray.withAlphaComponent(0.25), renderingMode: .alwaysOriginal)
                case .detailDisclosureButton:
                    trailingIconView.image = UIImage(systemName: "info.circle")?
                        .withTintColor(ChidoriMenuConfiguration.accentColor, renderingMode: .alwaysOriginal)
                case .checkmark:
                    trailingIconView.image = UIImage(systemName: "checkmark")?
                        .withTintColor(ChidoriMenuConfiguration.accentColor, renderingMode: .alwaysOriginal)
                case .detailButton:
                    trailingIconView.image = UIImage(systemName: "ellipsis.circle")?
                        .withTintColor(ChidoriMenuConfiguration.accentColor, renderingMode: .alwaysOriginal)
                default:
                    trailingIconView.image = nil
                }
                trailingIconView.isHidden = trailingIconView.image == nil
            }
        }

        var sectionHasAnyIcon: Bool = false

        override var accessibilityHint: String? {
            get { super.accessibilityHint ?? title }
            set { super.accessibilityHint = newValue }
        }

        let iconView = UIImageView()
        let titleLabel = UILabel()
        let trailingIconView = UIImageView()

        let topSep = UIView()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .clear
            selectionStyle = .none
            accessibilityTraits = [.button]

            accessoryView?.isUserInteractionEnabled = false
            preservesSuperviewLayoutMargins = false
            separatorInset = UIEdgeInsets.zero
            layoutMargins = UIEdgeInsets.zero
            topSep.backgroundColor = ChidoriMenu.dimmingSectionSepratorColor
            textLabel?.numberOfLines = 0

            contentView.addSubview(topSep)

            iconView.contentMode = .scaleAspectFit
            iconView.tintColor = .label
            contentView.addSubview(iconView)

            titleLabel.textColor = .label
            titleLabel.font = .preferredFont(forTextStyle: .body)
            titleLabel.textAlignment = .left
            titleLabel.numberOfLines = 0
            contentView.addSubview(titleLabel)

            trailingIconView.contentMode = .scaleAspectFit
            trailingIconView.layer.contentsGravity = .right
            trailingIconView.tintColor = ChidoriMenuConfiguration.accentColor
            contentView.addSubview(trailingIconView)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) { fatalError() }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            backgroundColor = selected ? Self.highlightCoverColor : .clear
        }

        override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            super.setSelected(highlighted, animated: animated)
            backgroundColor = highlighted ? Self.highlightCoverColor : .clear
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            let contentBounds = contentView.bounds

            topSep.frame = CGRect(
                x: 0,
                y: 0,
                width: contentBounds.width,
                height: 0.5
            )

            let iconFrame = CGRect(
                x: MenuLayout.horizontalPadding,
                y: (contentBounds.height - MenuLayout.iconSize) / 2,
                width: MenuLayout.iconSize,
                height: MenuLayout.iconSize
            )
            iconView.frame = iconFrame

            let trailingIconFrame = CGRect(
                x: contentBounds.width - MenuLayout.horizontalPadding - MenuLayout.iconSize,
                y: (contentBounds.height - MenuLayout.iconSize) / 2,
                width: MenuLayout.iconSize,
                height: MenuLayout.iconSize
            )
            trailingIconView.frame = trailingIconFrame

            let titleX: CGFloat = if sectionHasAnyIcon {
                MenuLayout.horizontalPadding + MenuLayout.iconSize + MenuLayout.spacing
            } else {
                MenuLayout.horizontalPadding
            }
            let titleWidth = contentBounds.width - titleX - MenuLayout.horizontalPadding - (trailingIconView.isHidden ? 0 : MenuLayout.iconSize + MenuLayout.spacing)

            let labelHeight = titleLabel.sizeThatFits(CGSize(width: titleWidth, height: .greatestFiniteMagnitude)).height

            let labelY = (contentBounds.height - labelHeight) / 2

            titleLabel.frame = CGRect(
                x: titleX,
                y: labelY,
                width: titleWidth,
                height: min(labelHeight, contentBounds.height)
            )
        }
    }

    class HeaderCell: UIView {
        let titleLabel: UILabel = .init()

        init() {
            // give it a default width so it wont animate bad
            super.init(frame: .init(
                x: MenuLayout.horizontalPadding,
                y: MenuLayout.verticalPadding,
                width: 250,
                height: 0
            ))

            titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            titleLabel.numberOfLines = 1
            titleLabel.textColor = .secondaryLabel
            titleLabel.textAlignment = .left
            addSubview(titleLabel)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError()
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            let titleHeight = titleLabel.font.lineHeight
            let titleY = (bounds.height - titleHeight) / 2 - MenuLayout.sectionTopPadding / 2

            titleLabel.frame = CGRect(
                x: MenuLayout.horizontalPadding,
                y: titleY,
                width: bounds.width - MenuLayout.horizontalPadding * 2,
                height: titleHeight
            )
        }
    }
}
