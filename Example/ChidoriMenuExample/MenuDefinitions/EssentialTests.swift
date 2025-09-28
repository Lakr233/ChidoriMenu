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
        menu: .init(title: "Attributes Test", children: [
            // MARK: - Normal Actions

            UIAction(title: "Normal Action", image: UIImage(systemName: "checkmark.circle")) { _ in
                showIndicator("Normal action executed")
            },

            // MARK: - Disabled Attribute Tests

            UIAction(title: "Disabled Action", image: UIImage(systemName: "xmark.circle"), attributes: .disabled) { _ in
                showIndicator("This should not appear")
            },
            UIAction(title: "Disabled + Destructive", image: UIImage(systemName: "trash.slash"), attributes: [.disabled, .destructive]) { _ in
                showIndicator("Disabled destructive")
            },

            // MARK: - Destructive Attribute Tests

            UIAction(title: "Destructive Action", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                showIndicator("Destructive action")
            },

            // MARK: - Keeps Menu Presented Tests

            {
                if #available(iOS 16.0, macCatalyst 16.0, *) {
                    UIAction(title: "Toggle Switch", image: UIImage(systemName: "switch.2"), attributes: [.keepsMenuPresented]) { action in
                        action.state = action.state == .on ? .off : .on
                        let stateText = action.state == .on ? "ON" : "OFF"
                        showIndicator("Switch: \(stateText) | Attributes: \(action.attributes.contains(.keepsMenuPresented) ? "keepsPresented" : "normal")")
                    }
                } else {
                    UIAction(title: "Toggle Switch (iOS 16+)", image: UIImage(systemName: "switch.2"), attributes: .disabled) { _ in
                        showIndicator("Requires iOS 16+")
                    }
                }
            }(),
            {
                if #available(iOS 16.0, macCatalyst 16.0, *) {
                    UIAction(title: "Counter (keeps presented)", image: UIImage(systemName: "number.circle"), attributes: [.keepsMenuPresented]) { action in
                        let currentCount = action.subtitle.flatMap { Int($0) } ?? 0
                        let newCount = currentCount + 1
                        action.subtitle = "\(newCount)"
                        showIndicator("Count: \(newCount) | State: \(action.state.rawValue) | Keeps: \(action.attributes.contains(.keepsMenuPresented))")
                    }
                } else {
                    UIAction(title: "Counter (iOS 16+)", image: UIImage(systemName: "number.circle"), attributes: .disabled) { _ in
                        showIndicator("Requires iOS 16+")
                    }
                }
            }(),
            {
                if #available(iOS 16.0, macCatalyst 16.0, *) {
                    UIAction(title: "Status Toggle", image: UIImage(systemName: "circle.lefthalf.filled"), attributes: [.keepsMenuPresented]) { action in
                        action.state = action.state == .mixed ? .on : action.state == .on ? .off : .mixed
                        let stateDesc = action.state == .on ? "Active" : action.state == .off ? "Inactive" : "Mixed"
                        showIndicator("Status: \(stateDesc) | Raw: \(action.state.rawValue)")
                    }
                } else {
                    UIAction(title: "Status Toggle (iOS 16+)", image: UIImage(systemName: "circle.lefthalf.filled"), attributes: .disabled) { _ in
                        showIndicator("Requires iOS 16+")
                    }
                }
            }(),

            // MARK: - Combined Attributes Test

            UIMenu(title: "Combined Tests", children: [
                UIAction(title: "Normal in Submenu", image: UIImage(systemName: "circle")) { _ in
                    showIndicator("Normal submenu action")
                },
                UIAction(title: "Disabled in Submenu", image: UIImage(systemName: "circle.slash"), attributes: .disabled) { _ in
                    showIndicator("Should not appear")
                },
                {
                    if #available(iOS 16.0, macCatalyst 16.0, *) {
                        UIAction(title: "Keeps Presented in Submenu", image: UIImage(systemName: "circle.dashed"), attributes: [.keepsMenuPresented]) { action in
                            action.state = action.state == .on ? .off : .on
                            showIndicator("Submenu toggle: \(action.state == .on ? "ON" : "OFF")")
                        }
                    } else {
                        UIAction(title: "Keeps Presented (iOS 16+)", image: UIImage(systemName: "circle.dashed"), attributes: .disabled) { _ in
                            showIndicator("Requires iOS 16+")
                        }
                    }
                }(),
            ]),
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
            UIMenu(title: "Group with Title", options: [.displayInline], children: [
                UIAction(title: "Sub Action D", image: UIImage(systemName: "d.circle")) { _ in showIndicator("D") },
                UIAction(title: "Sub Action E", image: UIImage(systemName: "e.circle")) { _ in showIndicator("E") },
                UIAction(title: "Sub Action F", image: UIImage(systemName: "f.circle")) { _ in showIndicator("F") },
            ]),
            UIMenu(title: "Folded without Icon", children: [
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
