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
        let horizontalStackView = UIStackView()

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

            topSep.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(topSep)
            NSLayoutConstraint.activate([
                topSep.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                topSep.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                topSep.heightAnchor.constraint(equalToConstant: 0.5),
                topSep.topAnchor.constraint(equalTo: contentView.topAnchor),
            ])

            horizontalStackView.axis = .horizontal
            horizontalStackView.spacing = 8
            horizontalStackView.distribution = .fill
            horizontalStackView.alignment = .center
            contentView.addSubview(horizontalStackView)
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                horizontalStackView.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: 8
                ),
                horizontalStackView.topAnchor.constraint(
                    equalTo: contentView.topAnchor,
                    constant: 8
                ),
                horizontalStackView.bottomAnchor.constraint(
                    equalTo: contentView.bottomAnchor,
                    constant: -8
                ),
                horizontalStackView.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -8
                ),
            ])

            iconView.contentMode = .scaleAspectFit
            iconView.tintColor = .label
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.setContentCompressionResistancePriority(.required, for: .horizontal)
            iconView.setContentHuggingPriority(.required, for: .horizontal)
            horizontalStackView.addArrangedSubview(iconView)
            NSLayoutConstraint.activate([
                iconView.widthAnchor.constraint(equalToConstant: 22),
                iconView.heightAnchor.constraint(equalToConstant: 22),
            ])

            titleLabel.textColor = .label
            titleLabel.font = .preferredFont(forTextStyle: .body)
            titleLabel.textAlignment = .left
            titleLabel.numberOfLines = 0
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            horizontalStackView.addArrangedSubview(titleLabel)

            trailingIconView.contentMode = .scaleAspectFit
            trailingIconView.layer.contentsGravity = .right
            trailingIconView.tintColor = ChidoriMenuConfiguration.accentColor
            trailingIconView.translatesAutoresizingMaskIntoConstraints = false
            trailingIconView.setContentCompressionResistancePriority(.required, for: .horizontal)
            trailingIconView.setContentHuggingPriority(.required, for: .horizontal)
            horizontalStackView.addArrangedSubview(trailingIconView)
            NSLayoutConstraint.activate([
                trailingIconView.heightAnchor.constraint(equalToConstant: 22),
            ])
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
