//
//  EssentialTests.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum EssentialTests {
    // MARK: - Basic Functionality

    static let basicMenu: MenuDefinition = .init(
        title: "Basic Menu",
        menu: .init(children: [
            UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                showIndicator("Copied")
            },
            UIAction(title: "Paste", image: UIImage(systemName: "doc.on.doc"), attributes: .disabled) { _ in
                showIndicator("Pasted")
            },
            UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                showIndicator("Deleted")
            },
        ])
    )

    // MARK: - Nested Menus

    static let nestedMenu: MenuDefinition = .init(
        title: "Nested Menu",
        menu: .init(title: "Root Menu", children: [
            UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                showIndicator("Copied")
            },
            UIMenu(title: "Edit", children: [
                UIAction(title: "Cut", image: UIImage(systemName: "scissors")) { _ in
                    showIndicator("Cut")
                },
                UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                    showIndicator("Copy")
                },
                UIAction(title: "Paste", image: UIImage(systemName: "doc.on.clipboard")) { _ in
                    showIndicator("Paste")
                },
            ]),
            UIMenu(title: "View", children: [
                UIAction(title: "Zoom In", image: UIImage(systemName: "plus.magnifyingglass")) { _ in
                    showIndicator("Zoom In")
                },
                UIAction(title: "Zoom Out", image: UIImage(systemName: "minus.magnifyingglass")) { _ in
                    showIndicator("Zoom Out")
                },
            ]),
        ])
    )

    // MARK: - Menu Attributes

    static let attributesMenu: MenuDefinition = .init(
        title: "Menu Attributes",
        menu: .init(children: [
            UIAction(title: "Normal Action", image: UIImage(systemName: "checkmark.circle")) { _ in
                showIndicator("Normal")
            },
            UIAction(title: "Disabled Action", image: UIImage(systemName: "xmark.circle"), attributes: .disabled) { _ in
                showIndicator("Should not appear")
            },
            UIAction(title: "Destructive Action", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                showIndicator("Destructive")
            },
            {
                if #available(iOS 16.0, macCatalyst 16.0, *) {
                    UIAction(title: "Toggle State", image: UIImage(systemName: "checkmark.circle"), attributes: [.keepsMenuPresented]) { action in
                        action.state = action.state == .on ? .off : .on
                        showIndicator("State: \(action.state == .on ? "ON" : "OFF")")
                    }
                } else {
                    UIAction(title: "Toggle State (iOS 16+)", image: UIImage(systemName: "checkmark.circle"), attributes: .disabled) { _ in
                        showIndicator("iOS 16+ only")
                    }
                }
            }(),
        ])
    )

    // MARK: - Long Menu

    static let longMenu: MenuDefinition = .init(
        title: "Long Menu",
        menu: .init(children: [
            UIAction(title: "Action 1", image: UIImage(systemName: "1.circle")) { _ in showIndicator("1") },
            UIAction(title: "Action 2", image: UIImage(systemName: "2.circle")) { _ in showIndicator("2") },
            UIAction(title: "Action 3", image: UIImage(systemName: "3.circle")) { _ in showIndicator("3") },
            UIMenu(options: [.displayInline], children: [
                UIAction(title: "Sub Action A", image: UIImage(systemName: "a.circle")) { _ in showIndicator("A") },
                UIAction(title: "Sub Action B", image: UIImage(systemName: "b.circle")) { _ in showIndicator("B") },
                UIAction(title: "Sub Action C", image: UIImage(systemName: "c.circle")) { _ in showIndicator("C") },
            ]),
            UIMenu(options: [.displayInline], children: [
                UIAction(title: "Sub Action D", image: UIImage(systemName: "d.circle")) { _ in showIndicator("D") },
                UIAction(title: "Sub Action E", image: UIImage(systemName: "e.circle")) { _ in showIndicator("E") },
                UIAction(title: "Sub Action F", image: UIImage(systemName: "f.circle")) { _ in showIndicator("F") },
            ]),
        ])
    )

    static let allTests: [MenuDefinition] = [
        basicMenu,
        nestedMenu,
        attributesMenu,
        longMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
