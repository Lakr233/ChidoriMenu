//
//  ChidoriMenu+Constant.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

extension ChidoriMenu {
    static let width: CGFloat = 256
    static let cornerRadius: CGFloat = 14
    static let shadowRadius: CGFloat = 24
    static let sectionTopPadding: CGFloat = 8
    static let offsetY: CGFloat = 16

    static let dimmingBackgroundColor = UIColor.black.withAlphaComponent(0.2)
    static let dimmingSectionSepratorColor = UIColor.black.withAlphaComponent(0.1)
}

extension ChidoriMenu.Cell {
    static let horizontalPadding: CGFloat = 12
    static let verticalPadding: CGFloat = 12.0
    static let iconTrailingOffset: CGFloat = 24.0
    static let titleToIconMinSpacing: CGFloat = -16.0
    static let highlightCoverColor = UIColor.black.withAlphaComponent(0.05)
}
