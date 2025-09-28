//
//  LayoutTests.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum LayoutTests {
    static let longTextMenu: MenuDefinition = .init(
        title: "Long Text Test",
        menu: UIMenu(
            children: [
                UIMenu(
                    title: "Configuration Options with Long Title",
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: NSLocalizedString("Hugging Face", comment: "")) { _ in
                            showIndicator("Hugging Face")
                        },
                        UIAction(title: NSLocalizedString("Model Scope", comment: "")) { _ in
                            showIndicator("Model Scope")
                        },
                    ]
                ),
                UIMenu(
                    title: NSLocalizedString("Cloud Model", comment: ""),
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: NSLocalizedString("OpenAI API Compatible", comment: ""), state: .on) { _ in
                            showIndicator("OpenAI API")
                        },
                    ]
                ),
                UIMenu(
                    title: NSLocalizedString("Advanced Settings", comment: ""),
                    children: [
                        UIAction(title: NSLocalizedString("Custom Configuration", comment: "")) { _ in
                            showIndicator("Custom Config")
                        },
                    ]
                ),
            ]
        )
    )

    static let dynamicWidthMenu: MenuDefinition = .init(
        title: "Dynamic Width Test",
        menu: .init(children: [
            UIAction(title: "Short") { _ in
                showIndicator("Short action")
            },
            UIAction(title: "Medium length action") { _ in
                showIndicator("Medium action")
            },
            UIAction(title: "Very long action title that should expand the menu width") { _ in
                showIndicator("Long action")
            },
            UIAction(
                title: "Action with icon",
                image: UIImage(systemName: "star")
            ) { _ in
                showIndicator("Icon action")
            },
        ])
    )

    static let iconAlignmentMenu: MenuDefinition = .init(
        title: "Icon Alignment Test",
        menu: .init(children: [
            UIAction(
                title: "Single line with icon",
                image: UIImage(systemName: "star.fill")
            ) { _ in
                showIndicator("Single line icon")
            },
            UIAction(
                title: "Multi-line text with icon that spans multiple lines to test vertical centering",
                image: UIImage(systemName: "heart.fill")
            ) { _ in
                showIndicator("Multi-line icon")
            },
            UIAction(
                title: "Short",
                image: UIImage(systemName: "circle.fill")
            ) { _ in
                showIndicator("Short icon")
            },
        ])
    )

    static let multiLineTextMenu: MenuDefinition = .init(
        title: "Multi-line Text Test",
        menu: .init(children: [
            UIAction(title: "Single line text") { _ in
                showIndicator("Single line")
            },
            UIAction(title: "Two line text that wraps to the next line for proper testing") { _ in
                showIndicator("Two lines")
            },
            UIAction(title: "Very long text that should wrap across multiple lines to test the layout and vertical centering properly") { _ in
                showIndicator("Multi-line")
            },
            UIAction(
                title: "Multi-line with icon that should be vertically centered",
                image: UIImage(systemName: "text.alignleft")
            ) { _ in
                showIndicator("Multi-line icon")
            },
        ])
    )

    static let responsiveWidthMenu: MenuDefinition = .init(
        title: "Responsive Width Test",
        menu: .init(children: [
            UIAction(title: "Normal width item") { _ in
                showIndicator("Normal")
            },
            UIAction(title: "Very long item that tests the min(max(width) + 32, available - 64) formula") { _ in
                showIndicator("Long formula test")
            },
            UIAction(
                title: "Item with icon and long text",
                image: UIImage(systemName: "arrow.right")
            ) { _ in
                showIndicator("Icon + long")
            },
            UIAction(
                title: "Short",
                image: UIImage(systemName: "checkmark")
            ) { _ in
                showIndicator("Short icon")
            },
        ])
    )

    static let customWidthMenu: MenuDefinition = .init(
        title: "Custom Width Test",
        menu: .init(children: [
            UIAction(title: "This menu uses custom width") { _ in
                showIndicator("Custom width")
            },
            UIAction(title: "Set to 350 points") { _ in
                showIndicator("350 width")
            },
        ])
    )

    static let allTests: [MenuDefinition] = [
        longTextMenu,
        dynamicWidthMenu,
        iconAlignmentMenu,
        multiLineTextMenu,
        responsiveWidthMenu,
        customWidthMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
