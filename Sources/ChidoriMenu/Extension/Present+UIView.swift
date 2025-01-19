//
//  Present+UIView.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

public extension UIView {
    func present(menu: UIMenu) {
        guard let presenter = parentViewController else { return }
        let origin = convert(CGPointZero, to: window)
        let chidoriMenu = ChidoriMenu(menu: menu, summonPoint: origin)
        presenter.present(chidoriMenu, animated: true) {
            if menu.children.isEmpty { chidoriMenu.dismiss(animated: true) }
        }
    }
}
