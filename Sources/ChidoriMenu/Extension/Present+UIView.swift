//
//  Present+UIView.swift
//  ChidoriMenu
//
//  Created by 秋星桥 on 1/19/25.
//

import UIKit

public extension UIView {
    func present(
        menu: UIMenu,
        anchorPoint: CGPoint? = nil,
        controllerDidLoad: @escaping (UIViewController) -> () = { _ in },
        controllerDidPresent: @escaping (UIViewController) -> () = { _ in }
    ) {
        guard let presenter = parentViewController else { return }
        let chidoriMenu = ChidoriMenu(
            menu: menu,
            anchorPoint: convert(.init(
                x: anchorPoint?.x ?? bounds.midX,
                y: anchorPoint?.y ?? bounds.midY
            ), to: window)
        )
        controllerDidLoad(chidoriMenu)
        presenter.present(chidoriMenu, animated: true) {
            controllerDidPresent(chidoriMenu)
            chidoriMenu.dismissIfEmpty()
        }
    }
}
