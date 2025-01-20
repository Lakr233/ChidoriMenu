//
//  ChidoriMenu+Constant.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

extension ChidoriMenu {
    static let width: CGFloat = 256
    static let cornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = cornerRadius
    static let sectionTopPadding: CGFloat = 6
    static let offsetY: CGFloat = 10

    static let dimmingBackgroundColor = UIColor.black.withAlphaComponent(0.1)
    static let dimmingSectionSepratorColor = UIColor.black.withAlphaComponent(0.1)
    static let dimmingSectionSepratorHeight: CGFloat = 4

    static let stackScaleFactor: CGFloat = 0.05
}

extension ChidoriMenu.Cell {
    static let horizontalPadding: CGFloat = 10
    static let verticalPadding: CGFloat = 10
    static let iconTrailingOffset: CGFloat = 20
    static let titleToIconMinSpacing: CGFloat = -10
    static let highlightCoverColor = UIColor.black.withAlphaComponent(0.05)
}
