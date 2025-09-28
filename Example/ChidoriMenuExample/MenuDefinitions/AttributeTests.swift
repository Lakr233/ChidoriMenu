//
//  AttributeTests.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum AttributeTests {
    static let attributesMenu: MenuDefinition = .init(
        title: "UIMenuElement Attributes Test",
        menu: .init(children: [
            UIAction(
                title: "Normal Action",
                image: UIImage(systemName: "checkmark.circle")
            ) { _ in
                showIndicator("Normal Action")
            },
            UIAction(
                title: "Disabled Action",
                image: UIImage(systemName: "xmark.circle"),
                attributes: .disabled
            ) { _ in
                showIndicator("This should not appear")
            },
            UIAction(
                title: "Destructive Action",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                showIndicator("Destructive Action")
            },
        ])
    )

    static let keepsMenuPresentedMenu: MenuDefinition = .init(
        title: "keepsMenuPresented Test",
        menu: .init(children: [
            UIAction(
                title: "Normal Action (Dismisses)",
                image: UIImage(systemName: "arrow.down.circle")
            ) { _ in
                showIndicator("Menu will dismiss")
            },
            {
                if #available(iOS 16.0, macCatalyst 16.0, *) {
                    UIAction(
                        title: "Toggle Checkmark",
                        image: UIImage(systemName: "checkmark.circle"),
                        attributes: [.keepsMenuPresented]
                    ) { action in
                        action.state = action.state == .on ? .off : .on
                        showIndicator("State toggled: \(action.state == .on ? "ON" : "OFF")")
                    }
                } else {
                    UIAction(
                        title: "Toggle Checkmark (iOS 16+)",
                        image: UIImage(systemName: "checkmark.circle"),
                        attributes: .disabled
                    ) { _ in
                        showIndicator("iOS 16+ only")
                    }
                }
            }(),
            UIAction(
                title: "Another Normal Action",
                image: UIImage(systemName: "checkmark.circle")
            ) { _ in
                showIndicator("Menu will dismiss")
            },
        ])
    )

    static let combinedAttributesMenu: MenuDefinition = .init(
        title: "Combined Attributes Test",
        menu: .init(children: [
            UIAction(
                title: "Normal Action",
                image: UIImage(systemName: "circle")
            ) { _ in
                showIndicator("Normal")
            },
            UIAction(
                title: "Disabled Destructive",
                image: UIImage(systemName: "xmark.circle"),
                attributes: [.disabled, .destructive]
            ) { _ in
                showIndicator("Should not appear")
            },
            {
                if #available(iOS 16.0, macCatalyst 16.0, *) {
                    UIAction(
                        title: "Destructive Keeps Presented",
                        image: UIImage(systemName: "exclamationmark.triangle"),
                        attributes: [.destructive, .keepsMenuPresented]
                    ) { _ in
                        showIndicator("Destructive but stays")
                    }
                } else {
                    UIAction(
                        title: "Destructive (iOS 16+ for keepsMenuPresented)",
                        image: UIImage(systemName: "exclamationmark.triangle"),
                        attributes: .destructive
                    ) { _ in
                        showIndicator("Destructive")
                    }
                }
            }(),
        ])
    )

    static let allTests: [MenuDefinition] = [
        attributesMenu,
        keepsMenuPresentedMenu,
        combinedAttributesMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
