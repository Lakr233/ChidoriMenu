//
//  Present+UIView.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

public extension UIView {
    func present(menu: UIMenu, summonPoint: CGPoint? = nil) {
        guard let presenter = parentViewController else { return }
        let chidoriMenu = ChidoriMenu(
            menu: menu,
            summonPoint: summonPoint ?? convert(.init(
                x: bounds.midX,
                y: bounds.midY
            ), to: window)
        )
        presenter.present(chidoriMenu, animated: true) {
            chidoriMenu.dismissIfEmpty()
        }
    }
}
