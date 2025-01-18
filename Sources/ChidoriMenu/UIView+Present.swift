//
//  UIView+Present.swift
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
        chidoriMenu.delegate = MenuDelegate.shared
        presenter.present(chidoriMenu, animated: true) {
            if menu.children.isEmpty { chidoriMenu.dismiss(animated: true) }
        }
    }
}

private class MenuDelegate: NSObject, ChidoriDelegate {
    static let shared = MenuDelegate()

    func didSelectAction(_ action: UIAction) {
        guard action.responds(to: NSSelectorFromString("handler")),
              let handler = action.value(forKey: "_handler")
        else { return }
        typealias ActionBlock = @convention(block) (UIAction) -> Void
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(handler as AnyObject).toOpaque())
        let block = unsafeBitCast(blockPtr, to: ActionBlock.self)
        return block(action)
    }
}
