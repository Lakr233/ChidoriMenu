//
//  MenuStructureTests.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum MenuStructureTests {
    // MARK: - Nested Menu Tests

    static let nestedMenu: MenuDefinition = .init(
        title: "Nested Menu",
        menu: .init(title: "Root Menu", children: [
            UIAction(
                title: "Copy",
                image: UIImage(systemName: "doc.on.doc"),
                state: .on
            ) { _ in
                showIndicator("Copied")
            },
            UIMenu(
                title: "Child Menu",
                image: .init(systemName: "menucard"),
                children: [
                    UIAction(
                        title: "Copy",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        showIndicator("Copied")
                    },
                    UIMenu(
                        title: "Grandchild Menu",
                        image: .init(systemName: "menucard"),
                        children: [
                            UIAction(
                                title: "Copy",
                                image: UIImage(systemName: "doc.on.doc")
                            ) { _ in
                                showIndicator("Copied")
                            },
                        ]
                    ),
                ]
            ),
            UIMenu(
                title: "Inline Menu",
                image: UIImage(systemName: "arrow.right"),
                options: [.displayInline],
                children: [
                    UIAction(
                        title: "Copy",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        showIndicator("Copied")
                    },
                    UIAction(
                        title: "Paste",
                        image: UIImage(systemName: "doc.on.doc"),
                        attributes: .disabled
                    ) { _ in
                        showIndicator("Pasted")
                    },
                    UIAction(
                        title: "Delete",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive
                    ) { _ in
                        showIndicator("Deleted")
                    },
                ]
            ),
        ])
    )

    static let complexNestedMenu: MenuDefinition = .init(
        title: "Complex Nested Menu",
        menu: .init(title: "Main Menu", children: [
            UIAction(
                title: "Quick Action",
                image: UIImage(systemName: "bolt")
            ) { _ in
                showIndicator("Quick Action")
            },
            UIMenu(
                title: "File Operations",
                image: UIImage(systemName: "folder"),
                children: [
                    UIAction(
                        title: "New File",
                        image: UIImage(systemName: "doc.badge.plus")
                    ) { _ in
                        showIndicator("New File")
                    },
                    UIAction(
                        title: "Open Recent",
                        image: UIImage(systemName: "clock")
                    ) { _ in
                        showIndicator("Open Recent")
                    },
                    UIMenu(
                        title: "Import",
                        image: UIImage(systemName: "square.and.arrow.down"),
                        children: [
                            UIAction(
                                title: "From Photos",
                                image: UIImage(systemName: "photo")
                            ) { _ in
                                showIndicator("From Photos")
                            },
                            UIAction(
                                title: "From Files",
                                image: UIImage(systemName: "folder")
                            ) { _ in
                                showIndicator("From Files")
                            },
                            UIAction(
                                title: "From URL",
                                image: UIImage(systemName: "link")
                            ) { _ in
                                showIndicator("From URL")
                            },
                        ]
                    ),
                ]
            ),
            UIMenu(
                title: "Edit",
                image: UIImage(systemName: "pencil"),
                options: [.displayInline],
                children: [
                    UIAction(
                        title: "Cut",
                        image: UIImage(systemName: "scissors")
                    ) { _ in
                        showIndicator("Cut")
                    },
                    UIAction(
                        title: "Copy",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        showIndicator("Copy")
                    },
                    UIAction(
                        title: "Paste",
                        image: UIImage(systemName: "doc.on.clipboard")
                    ) { _ in
                        showIndicator("Paste")
                    },
                ]
            ),
            UIMenu(
                title: "View",
                image: UIImage(systemName: "eye"),
                children: [
                    UIAction(
                        title: "Zoom In",
                        image: UIImage(systemName: "plus.magnifyingglass")
                    ) { _ in
                        showIndicator("Zoom In")
                    },
                    UIAction(
                        title: "Zoom Out",
                        image: UIImage(systemName: "minus.magnifyingglass")
                    ) { _ in
                        showIndicator("Zoom Out")
                    },
                    UIAction(
                        title: "Actual Size",
                        image: UIImage(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                    ) { _ in
                        showIndicator("Actual Size")
                    },
                ]
            ),
        ])
    )

    // MARK: - Long Menu Tests

    static let longMenu: MenuDefinition = .init(
        title: "Long Menu",
        menu: .init(title: "Root Menu", children: [
            UIAction(title: "Copy 1", image: UIImage(systemName: "doc.on.doc")) { _ in
                showIndicator("Copied 1")
            },
            UIAction(title: "Paste 1", image: UIImage(systemName: "doc.on.doc"), attributes: .disabled) { _ in
                showIndicator("Pasted 1")
            },
            UIAction(title: "Delete 1", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                showIndicator("Deleted 1")
            },
            UIMenu(
                options: [.displayInline],
                children: [
                    UIAction(title: "Copy 2", image: UIImage(systemName: "doc.on.doc")) { _ in
                        showIndicator("Copied 2")
                    },
                    UIAction(title: "Paste 2", image: UIImage(systemName: "doc.on.doc"), attributes: .disabled) { _ in
                        showIndicator("Pasted 2")
                    },
                    UIAction(title: "Delete 2", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                        showIndicator("Deleted 2")
                    },
                ]
            ),
            UIMenu(
                options: [.displayInline],
                children: [
                    UIAction(title: "Copy 3", image: UIImage(systemName: "doc.on.doc")) { _ in
                        showIndicator("Copied 3")
                    },
                    UIAction(title: "Paste 3", image: UIImage(systemName: "doc.on.doc"), attributes: .disabled) { _ in
                        showIndicator("Pasted 3")
                    },
                    UIAction(title: "Delete 3", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                        showIndicator("Deleted 3")
                    },
                ]
            ),
            UIMenu(
                title: "Submenu",
                children: [
                    UIAction(title: "Copy 4", image: UIImage(systemName: "doc.on.doc")) { _ in
                        showIndicator("Copied 4")
                    },
                    UIAction(title: "Paste 4", image: UIImage(systemName: "doc.on.doc"), attributes: .disabled) { _ in
                        showIndicator("Pasted 4")
                    },
                    UIAction(title: "Delete 4", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                        showIndicator("Deleted 4")
                    },
                ]
            ),
        ])
    )

    static let allTests: [MenuDefinition] = [
        nestedMenu,
        complexNestedMenu,
        longMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
