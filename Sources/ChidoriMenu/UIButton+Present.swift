//
//  UIButton+Present.swift
//
//
//  Created by QAQ on 2023/9/16.
//

import UIKit

public extension UIButton {
    func presentMenu() {
        guard let menu = retrieveMenu() else { return }
        let center = convert(center, to: parentViewController?.view)
        let chidoriMenu = ChidoriMenu(menu: menu, summonPoint: center)
        parentViewController?.present(chidoriMenu, animated: true, completion: nil)
    }
}

private extension UIButton {
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    private func retrieveMenu() -> UIMenu? {
        for interaction in interactions {
            if let menuInteraction = interaction as? UIContextMenuInteraction,
               let menuConfig = menuInteraction.delegate?.contextMenuInteraction(
                   menuInteraction,
                   configurationForMenuAtLocation: .zero
               ),
               let menu = menuConfig.retrieveMenu()
            {
                return menu
            }
        }
        if let menuConfig = contextMenuInteraction(
            .init(delegate: JustGiveMeMenu.shared),
            configurationForMenuAtLocation: .zero
        ), let menu = menuConfig.retrieveMenu() {
            return menu
        }
        return nil
    }
}

private class JustGiveMeMenu: NSObject, UIContextMenuInteractionDelegate {
    static let shared = JustGiveMeMenu()

    func contextMenuInteraction(_: UIContextMenuInteraction, configurationForMenuAtLocation _: CGPoint) -> UIContextMenuConfiguration? {
        nil
    }
}

private extension UIContextMenuConfiguration {
    func retrieveMenu() -> UIMenu? {
        guard responds(to: NSSelectorFromString("actionProvider")),
              let actionProvider = value(forKey: "_actionProvider")
        else { return nil }
        typealias ActionProviderBlock = @convention(block) ([UIMenuElement]) -> (UIMenu?)
        let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(actionProvider as AnyObject).toOpaque())
        let handler = unsafeBitCast(blockPtr, to: ActionProviderBlock.self)
        return handler([])
    }
}
