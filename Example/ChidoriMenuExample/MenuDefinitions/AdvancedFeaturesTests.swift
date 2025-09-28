//
//  AdvancedFeaturesTests.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum AdvancedFeaturesTests {
    // MARK: - Deferred Menu Tests

    static let deferredMenu: MenuDefinition = .init(
        title: "Deferred Menu Elements",
        menu: .init(children: [
            UIDeferredMenuElement.uncached {
                $0([
                    UIAction(
                        title: "Dynamic Item 1",
                        image: .init(systemName: "wind")
                    ) { _ in
                        showIndicator("Dynamic 1")
                    },
                    UIAction(
                        title: "Dynamic Item 2",
                        image: .init(systemName: "wind")
                    ) { _ in
                        showIndicator("Dynamic 2")
                    },
                    UIDeferredMenuElement.uncached {
                        $0([
                            UIAction(
                                title: "Nested Dynamic 1",
                                image: .init(systemName: "wind")
                            ) { _ in
                                showIndicator("Nested 1")
                            },
                            UIAction(
                                title: "Nested Dynamic 2",
                                image: .init(systemName: "wind"),
                                state: .on
                            ) { _ in
                                showIndicator("Nested 2")
                            },
                        ])
                    },
                ])
            },
        ])
    )

    static let backportMenu: MenuDefinition = .init(
        title: "DeferredMenu Backport",
        menu: DeferredMenu.uncached {
            let item = Int.random(in: 1111 ... 9999)
            print("DeferredMenu returning new elements \(item)")
            return UIMenu(title: "DeferredMenu", children: [
                UIAction(title: String(item)) { _ in
                    showIndicator("Random: \(item)")
                },
            ])
        }
    )

    // MARK: - Layout Tests

    static let longTextMenu: MenuDefinition = .init(
        title: "Long Text Layout",
        menu: UIMenu(
            children: [
                UIMenu(
                    title: "Configuration Options with Long Title",
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: "Hugging Face") { _ in
                            showIndicator("Hugging Face")
                        },
                        UIAction(title: "Model Scope") { _ in
                            showIndicator("Model Scope")
                        },
                    ]
                ),
                UIMenu(
                    title: "Cloud Model",
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: "OpenAI API Compatible", state: .on) { _ in
                            showIndicator("OpenAI API")
                        },
                    ]
                ),
                UIMenu(
                    title: "Advanced Settings",
                    children: [
                        UIAction(title: "Custom Configuration") { _ in
                            showIndicator("Custom Config")
                        },
                    ]
                ),
            ]
        )
    )

    static let dynamicWidthMenu: MenuDefinition = .init(
        title: "Dynamic Width",
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
        title: "Icon Alignment",
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
        title: "Multi-line Text",
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
        title: "Responsive Width",
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
        title: "Custom Width",
        menu: .init(children: [
            UIAction(title: "This menu uses custom width") { _ in
                showIndicator("Custom width")
            },
            UIAction(title: "Set to 350 points") { _ in
                showIndicator("350 width")
            },
        ])
    )

    // MARK: - Accessibility Tests

    static let accessibilityMenu: MenuDefinition = .init(
        title: "Accessibility Features",
        menu: .init(children: [
            UIAction(
                title: "VoiceOver Friendly Action",
                image: UIImage(systemName: "speaker.wave.2")
            ) { _ in
                showIndicator("VoiceOver Action")
            },
            UIAction(
                title: "High Contrast Mode Test",
                image: UIImage(systemName: "eye")
            ) { _ in
                showIndicator("High Contrast")
            },
            UIAction(
                title: "Large Text Support",
                image: UIImage(systemName: "textformat.size")
            ) { _ in
                showIndicator("Large Text")
            },
            UIAction(
                title: "Reduced Motion Test",
                image: UIImage(systemName: "hare")
            ) { _ in
                showIndicator("Reduced Motion")
            },
        ])
    )

    static let screenReaderMenu: MenuDefinition = .init(
        title: "Screen Reader Support",
        menu: .init(children: [
            UIAction(
                title: "Action with clear description",
                image: UIImage(systemName: "checkmark.circle")
            ) { _ in
                showIndicator("Clear action")
            },
            UIAction(
                title: "Complex action with detailed explanation",
                image: UIImage(systemName: "info.circle")
            ) { _ in
                showIndicator("Complex action")
            },
            UIAction(
                title: "Destructive action - will delete item",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                showIndicator("Delete action")
            },
            UIAction(
                title: "Disabled action - not available",
                image: UIImage(systemName: "xmark.circle"),
                attributes: .disabled
            ) { _ in
                showIndicator("Should not appear")
            },
        ])
    )

    static let dynamicTypeMenu: MenuDefinition = .init(
        title: "Dynamic Type Support",
        menu: .init(children: [
            UIAction(
                title: "Short text",
                image: UIImage(systemName: "text.alignleft")
            ) { _ in
                showIndicator("Short")
            },
            UIAction(
                title: "Medium length text that should adapt to different font sizes",
                image: UIImage(systemName: "text.aligncenter")
            ) { _ in
                showIndicator("Medium")
            },
            UIAction(
                title: "Very long text that demonstrates how dynamic type affects menu layout and readability across different accessibility settings",
                image: UIImage(systemName: "text.alignright")
            ) { _ in
                showIndicator("Long")
            },
        ])
    )

    static let allTests: [MenuDefinition] = [
        deferredMenu,
        backportMenu,
        longTextMenu,
        dynamicWidthMenu,
        iconAlignmentMenu,
        multiLineTextMenu,
        responsiveWidthMenu,
        customWidthMenu,
        accessibilityMenu,
        screenReaderMenu,
        dynamicTypeMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
