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
                setNeedsUpdateConstraints()
            }
        }

        var isDestructive: Bool = false {
            didSet {
                let color: UIColor = isDestructive ? .systemRed : .label
                titleLabel.textColor = color
                iconView.tintColor = color
            }
        }

        var iconImage: UIImage? {
            didSet {
                iconView.image = iconImage
                iconView.isHidden = iconImage == nil
                setNeedsUpdateConstraints()
            }
        }

        var trailingItem: UITableViewCell.AccessoryType = .none {
            didSet {
                switch trailingItem {
                case .disclosureIndicator:
                    trailingIconView.image = UIImage(systemName: "chevron.right")
                case .detailDisclosureButton:
                    trailingIconView.image = UIImage(systemName: "info.circle")
                case .checkmark:
                    trailingIconView.image = UIImage(systemName: "checkmark")
                case .detailButton:
                    trailingIconView.image = UIImage(systemName: "ellipsis.circle")
                default:
                    trailingIconView.image = nil
                }
                setNeedsUpdateConstraints()
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
        
        var removableConstraints: [NSLayoutConstraint] = []
        
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

            iconView.contentMode = .scaleAspectFit
            iconView.tintColor = .label
            iconView.tintAdjustmentMode = .normal
            iconView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(iconView)

            titleLabel.textColor = .label
            titleLabel.font = .preferredFont(forTextStyle: .body)
            titleLabel.textAlignment = .left
            titleLabel.numberOfLines = 0
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(titleLabel)
            
            trailingIconView.contentMode = .scaleAspectFit
            trailingIconView.layer.contentsGravity = .right
            trailingIconView.tintColor = ChidoriMenu.accentColor
            trailingIconView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(trailingIconView)
            
            NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            trailingIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            trailingIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trailingIconView.heightAnchor.constraint(equalToConstant: 18),
            ])
            
            setNeedsUpdateConstraints()
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
        
        override func updateConstraints() {
            super.updateConstraints()
            
            removableConstraints.forEach { $0.isActive = false }
            removableConstraints.removeAll()
            
            let titleLabelLeftAnchor = iconView.isHidden
                ? contentView.leadingAnchor
                : iconView.trailingAnchor
            
            let titleLabelTrailingAnchor = trailingIconView.image == nil
                ? contentView.trailingAnchor
                : trailingIconView.leadingAnchor
            
            removableConstraints.append(contentsOf: [
                titleLabel.leadingAnchor.constraint(equalTo: titleLabelLeftAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: titleLabelTrailingAnchor, constant: -8),
            ])
            
            removableConstraints.forEach { $0.isActive = true }
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
