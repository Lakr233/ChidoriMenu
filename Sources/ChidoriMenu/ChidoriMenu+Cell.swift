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
            didSet {
                titleLabel.text = menuTitle
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
                titleLabel.alpha = alpha
                iconView.alpha = alpha
                trailingIconView.alpha = alpha
            }
        }

        var iconImage: UIImage? {
            didSet {
                iconView.image = iconImage
                iconView.isHidden = iconImage == nil
            }
        }

        var trailingItem: UITableViewCell.AccessoryType = .none {
            didSet {
                switch trailingItem {
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

        override var accessibilityHint: String? {
            get { super.accessibilityHint ?? menuTitle }
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
            let horizontalPadding: CGFloat = 8
            let verticalPadding: CGFloat = 8
            let iconSize: CGFloat = 22
            let spacing: CGFloat = 8

            // Top separator
            topSep.frame = CGRect(
                x: 0,
                y: 0,
                width: contentBounds.width,
                height: 0.5
            )

            // Calculate vertical center position for icons and label
            let contentHeight = contentBounds.height - verticalPadding * 2
            let centerY = verticalPadding + contentHeight / 2

            // Icon - vertically centered
            let iconFrame = CGRect(
                x: horizontalPadding,
                y: centerY - iconSize / 2,
                width: iconSize,
                height: iconSize
            )
            iconView.frame = iconFrame

            // Trailing icon - vertically centered
            let trailingIconFrame = CGRect(
                x: contentBounds.width - horizontalPadding - iconSize,
                y: centerY - iconSize / 2,
                width: iconSize,
                height: iconSize
            )
            trailingIconView.frame = trailingIconFrame

            // Title label - vertically centered with proper height
            let titleX = iconView.isHidden ? horizontalPadding : iconFrame.maxX + spacing
            let titleWidth = contentBounds.width - titleX - horizontalPadding - (trailingIconView.isHidden ? 0 : iconSize + spacing)

            // Calculate label height based on content
            let labelHeight = titleLabel.sizeThatFits(CGSize(width: titleWidth, height: .greatestFiniteMagnitude)).height
            let labelY = centerY - labelHeight / 2

            titleLabel.frame = CGRect(
                x: titleX,
                y: labelY,
                width: titleWidth,
                height: min(labelHeight, contentHeight)
            )
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
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError()
        }

        override func layoutSubviews() {
            super.layoutSubviews()

            let horizontalPadding: CGFloat = 8
            let titleHeight = titleLabel.font.lineHeight
            let titleY = (bounds.height - titleHeight) / 2 - ChidoriMenu.sectionTopPadding / 2

            titleLabel.frame = CGRect(
                x: horizontalPadding,
                y: titleY,
                width: bounds.width - horizontalPadding * 2,
                height: titleHeight
            )
        }
    }
}
