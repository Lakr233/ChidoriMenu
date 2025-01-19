//
//  Present+UIButton.swift
//
//
//  Created by QAQ on 2023/9/16.
//

import UIKit

public extension UIButton {
    func presentMenu() {
        guard let menu = retrieveMenu() else { return }
        present(menu: menu)
    }
}

extension UIButton {
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

    func contextMenuInteraction(
        _: UIContextMenuInteraction,
        configurationForMenuAtLocation _: CGPoint
    ) -> UIContextMenuConfiguration? {
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
