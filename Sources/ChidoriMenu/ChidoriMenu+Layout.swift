//
//  ChidoriMenu+Layout.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

enum MenuLayout {
    static let width: CGFloat = 280
    static let cornerRadius: CGFloat = 14
    static let shadowRadius: CGFloat = cornerRadius
    static let sectionTopPadding: CGFloat = 6
    static let offsetY: CGFloat = 10

    static let dimmingBackgroundColor = UIColor.black.withAlphaComponent(0.1)
    static let dimmingSectionSepratorColor = UIColor.black.withAlphaComponent(0.1)
    static let dimmingSectionSepratorHeight: CGFloat = 4

    static let stackScaleFactor: CGFloat = 0.05

    // Layout constants
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 11
    static let iconSize: CGFloat = 22
    static let spacing: CGFloat = 12
    static let minRowHeight: CGFloat = 44
}
