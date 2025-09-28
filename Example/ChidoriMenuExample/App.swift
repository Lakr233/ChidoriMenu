//
//  App.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import SwiftUI

@main
struct ChidoriMenuExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            Content()
                .ignoresSafeArea()
                .navigationTitle("Chidori Menu")
        }
        .navigationViewStyle(.stack)
    }
}

struct Content: UIViewControllerRepresentable {
    class ContentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = FooterButton()
            view.addSubview(tableView)

            ChidoriMenuConfiguration.accentColor = .systemPink
            ChidoriMenuConfiguration.backgroundColor = .systemBackground
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            tableView.frame = view.bounds
        }

        struct Menu {
            let title: String
            let menu: UIMenu
        }

        var firstMenu: Menu = .init(title: "Show Menu Set", menu: .init(children: [
            UIAction(
                title: "Copy",
                image: UIImage(systemName: "doc.on.doc"),
                state: .on
            ) { _ in
                SPIndicatorView(title: "Copied", preset: .done).present()
            },
            UIAction(
                title: "Paste",
                image: UIImage(systemName: "doc.on.doc"),
                attributes: .disabled,
                state: .off
            ) { _ in
                SPIndicatorView(title: "Pasted", preset: .done).present()
            },
            UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive,
                state: .mixed
            ) { _ in
                SPIndicatorView(title: "Delete", preset: .done).present()
            },
        ]))

        var secondMenu: Menu = .init(title: "Show Nested Menu Set", menu: .init(title: "Root Menu", children: [
            UIAction(
                title: "Copy",
                image: UIImage(systemName: "doc.on.doc"),
                state: .on
            ) { _ in
                SPIndicatorView(title: "Copied", preset: .done).present()
            },
            UIMenu(
                title: "Child Menu",
                image: .init(systemName: "menucard"),
                children: [
                    UIAction(
                        title: "Copy",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        SPIndicatorView(title: "Copied", preset: .done).present()
                    },
                    UIMenu(
                        title: "Child Menu",
                        image: .init(systemName: "menucard"),
                        children: [
                            UIAction(
                                title: "Copy",
                                image: UIImage(systemName: "doc.on.doc")
                            ) { _ in
                                SPIndicatorView(title: "Copied", preset: .done).present()
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
                        SPIndicatorView(title: "Copied", preset: .done).present()
                    },
                    UIAction(
                        title: "Paste",
                        image: UIImage(systemName: "doc.on.doc"),
                        attributes: .disabled
                    ) { _ in
                        SPIndicatorView(title: "Pasted", preset: .done).present()
                    },
                    UIAction(
                        title: "Delete",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive
                    ) { _ in
                        SPIndicatorView(title: "Delete", preset: .done).present()
                    },
                ]
            ),
        ]))

        var veryLongMenu: Menu = .init(title: "Show Looong Menu Set", menu: .init(title: "Root Menu", children: [
            UIAction(
                title: "Copy 1",
                image: UIImage(systemName: "doc.on.doc")
            ) { _ in
                SPIndicatorView(title: "Copied", preset: .done).present()
            },
            UIAction(
                title: "Paste 1",
                image: UIImage(systemName: "doc.on.doc"),
                attributes: .disabled
            ) { _ in
                SPIndicatorView(title: "Pasted", preset: .done).present()
            },
            UIAction(
                title: "Delete 1",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                SPIndicatorView(title: "Delete", preset: .done).present()
            },
            UIMenu(
                options: [.displayInline],
                children: [
                    UIAction(
                        title: "Copy 2",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        SPIndicatorView(title: "Copied", preset: .done).present()
                    },
                    UIAction(
                        title: "Paste 2",
                        image: UIImage(systemName: "doc.on.doc"),
                        attributes: .disabled
                    ) { _ in
                        SPIndicatorView(title: "Pasted", preset: .done).present()
                    },
                    UIAction(
                        title: "Delete 2",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive
                    ) { _ in
                        SPIndicatorView(title: "Delete", preset: .done).present()
                    },
                ]
            ),
            UIMenu(
                options: [.displayInline],
                children: [
                    UIAction(
                        title: "Copy 3",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        SPIndicatorView(title: "Copied", preset: .done).present()
                    },
                    UIAction(
                        title: "Paste 3",
                        image: UIImage(systemName: "doc.on.doc"),
                        attributes: .disabled
                    ) { _ in
                        SPIndicatorView(title: "Pasted", preset: .done).present()
                    },
                    UIAction(
                        title: "Delete 3",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive
                    ) { _ in
                        SPIndicatorView(title: "Delete", preset: .done).present()
                    },
                ]
            ),
            UIMenu(
                title: "Submenu Here",
                children: [
                    UIAction(
                        title: "Copy 4",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        SPIndicatorView(title: "Copied", preset: .done).present()
                    },
                    UIAction(
                        title: "Paste 4",
                        image: UIImage(systemName: "doc.on.doc"),
                        attributes: .disabled
                    ) { _ in
                        SPIndicatorView(title: "Pasted", preset: .done).present()
                    },
                    UIAction(
                        title: "Delete 4",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive
                    ) { _ in
                        SPIndicatorView(title: "Delete", preset: .done).present()
                    },
                ]
            ),
            UIMenu(
                title: "Hello World",
                options: [.displayInline],
                children: [
                    UIAction(
                        title: "Copy 5",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        SPIndicatorView(title: "Copied", preset: .done).present()
                    },
                    UIAction(
                        title: "Paste 5",
                        image: UIImage(systemName: "doc.on.doc"),
                        attributes: .disabled
                    ) { _ in
                        SPIndicatorView(title: "Pasted", preset: .done).present()
                    },
                    UIAction(
                        title: "Delete 5",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive
                    ) { _ in
                        SPIndicatorView(title: "Delete", preset: .done).present()
                    },
                ]
            ),
            UIMenu(
                options: [.displayInline],
                children: [
                    UIAction(
                        title: "Copy 6",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        SPIndicatorView(title: "Copied", preset: .done).present()
                    },
                    UIAction(
                        title: "Paste 6",
                        image: UIImage(systemName: "doc.on.doc"),
                        attributes: .disabled
                    ) { _ in
                        SPIndicatorView(title: "Pasted", preset: .done).present()
                    },
                    UIAction(
                        title: "Delete 6",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive
                    ) { _ in
                        SPIndicatorView(title: "Delete", preset: .done).present()
                    },
                ]
            ),
            UIMenu(
                options: [.displayInline],
                children: [
                    UIAction(
                        title: "Copy 7",
                        image: UIImage(systemName: "doc.on.doc")
                    ) { _ in
                        SPIndicatorView(title: "Copied", preset: .done).present()
                    },
                    UIAction(
                        title: "Paste 7",
                        image: UIImage(systemName: "doc.on.doc"),
                        attributes: .disabled
                    ) { _ in
                        SPIndicatorView(title: "Pasted", preset: .done).present()
                    },
                    UIAction(
                        title: "Delete 7",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive
                    ) { _ in
                        SPIndicatorView(title: "Delete", preset: .done).present()
                    },
                ]
            ),
        ]))

        var deferredMenuElement: Menu = .init(title: "Show UIDeferredMenuElement", menu: .init(children: [
            UIDeferredMenuElement.uncached {
                $0([
                    UIAction(
                        title: "Hello World",
                        image: .init(systemName: "wind")
                    ) { _ in },
                    UIAction(
                        title: "UIDeferredMenuElement",
                        image: .init(systemName: "wind")
                    ) { _ in },
                    UIDeferredMenuElement.uncached {
                        $0([
                            UIAction(
                                title: "Hello World",
                                image: .init(systemName: "wind")
                            ) { _ in },
                            UIAction(
                                title: "Nested",
                                image: .init(systemName: "wind"),
                                state: .on
                            ) { _ in },
                            UIAction(
                                title: "UIDeferredMenuElement",
                                image: .init(systemName: "wind")
                            ) { _ in },
                        ])
                    },
                ])
            },
        ]))

        let productionTest: Menu = .init(title: "Production Test", menu: UIMenu(
            title: NSLocalizedString("Select Model Type", comment: ""),
            options: [.displayInline],
            children: [
                UIMenu(
                    title: NSLocalizedString("Local Model", comment: ""),
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: NSLocalizedString("Hugging Face", comment: "")) { _ in
                        },
                        UIAction(title: NSLocalizedString("Model Scope", comment: "")) { _ in
                        },
                    ]
                ),
                UIMenu(
                    title: NSLocalizedString("Cloud Model", comment: ""),
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: NSLocalizedString("OpenAI API Compatible", comment: "")) { _ in
                        },
                        UIMenu(
                            options: [.displayInline, .singleSelection],
                            children: [
                            ]
                        ),
                        UIMenu(
                            title: NSLocalizedString("Well Known Service Providers", comment: ""),
                            options: [.singleSelection],
                            children: [
                                UIAction(title: "OpenAI") { _ in
                                },
                                UIAction(title: "OpenRouter") { _ in
                                },
                                UIAction(title: "DeepSeek") { _ in
                                },
                                UIAction(title: "Groq") { _ in
                                },
                            ]
                        ),
                    ]
                ),
            ]
        ))

        let longTextTest: Menu = .init(title: "Loooong Menu Test", menu: UIMenu(
            children: [
                UIMenu(
                    title: "oooooooooooooooooooooooooooooooooooooooo",
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: NSLocalizedString("Hugging Face", comment: "")) { _ in
                        },
                        UIAction(title: NSLocalizedString("Model Scope", comment: "")) { _ in
                        },
                    ]
                ),
                UIMenu(
                    title: NSLocalizedString("Cloud Model", comment: ""),
                    options: [.displayInline, .singleSelection],
                    children: [
                        UIAction(title: NSLocalizedString("oooooooooooooooooooooooooooooo", comment: ""), state: .on) { _ in
                        },
                        UIMenu(
                            options: [.displayInline, .singleSelection],
                            children: [
                            ]
                        ),
                    ]
                ),
                UIMenu(
                    title: NSLocalizedString("oooooooooooooooooooooooooooooo", comment: ""),
                    children: [
                        UIAction(title: NSLocalizedString("oooooooooooooooooooooooooooooo", comment: "")) { _ in
                        },
                        UIMenu(
                            options: [.displayInline, .singleSelection],
                            children: [
                            ]
                        ),
                    ]
                ),
            ]
        ))

        let backportMenu: Menu = .init(title: "iOS 14- DeferredMenu Test", menu: DeferredMenu.uncached {
            let item = Int.random(in: 1111 ... 9999)
            print("DeferredMenu returning new elements \(item)")
            return UIMenu(title: "DeferredMenu", children: [
                UIAction(title: String(item)) { _ in
                },
            ])
        })

        let attributesMenu: Menu = .init(title: "UIMenuElement Attributes Test", menu: .init(children: [
            UIAction(
                title: "Normal Action",
                image: UIImage(systemName: "checkmark.circle")
            ) { _ in
                SPIndicatorView(title: "Normal Action", preset: .done).present()
            },
            UIAction(
                title: "Disabled Action",
                image: UIImage(systemName: "xmark.circle"),
                attributes: .disabled
            ) { _ in
                SPIndicatorView(title: "This should not appear", preset: .error).present()
            },
            UIAction(
                title: "Destructive Action",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                SPIndicatorView(title: "Destructive Action", preset: .error).present()
            },
        ]))

        let keepsMenuPresentedMenu: Menu = .init(title: "keepsMenuPresented Test", menu: .init(children: [
            UIAction(
                title: "Normal Action (Dismisses)",
                image: UIImage(systemName: "arrow.down.circle")
            ) { _ in
                SPIndicatorView(title: "Menu will dismiss", preset: .done).present()
            },
            {
                if #available(iOS 16.0, macCatalyst 16.0, *) {
                    UIAction(
                        title: "Toggle Checkmark",
                        image: UIImage(systemName: "checkmark.circle"),
                        attributes: [.keepsMenuPresented]
                    ) { action in
                        // Toggle state to demonstrate menu reload
                        action.state = action.state == .on ? .off : .on
                        SPIndicatorView(title: "State toggled: \(action.state == .on ? "ON" : "OFF")", preset: .done).present()
                    }
                } else {
                    UIAction(
                        title: "Toggle Checkmark (iOS 16+)",
                        image: UIImage(systemName: "checkmark.circle"),
                        attributes: .disabled
                    ) { _ in
                        SPIndicatorView(title: "iOS 16+ only", preset: .error).present()
                    }
                }
            }(),
            UIAction(
                title: "Another Normal Action",
                image: UIImage(systemName: "checkmark.circle")
            ) { _ in
                SPIndicatorView(title: "Menu will dismiss", preset: .done).present()
            },
        ]))

        let dynamicWidthMenu: Menu = .init(title: "Dynamic Width Test", menu: .init(children: [
            UIAction(title: "Short") { _ in
                SPIndicatorView(title: "Short action", preset: .done).present()
            },
            UIAction(title: "Medium length action") { _ in
                SPIndicatorView(title: "Medium action", preset: .done).present()
            },
            UIAction(title: "Very long action title that should expand the menu width") { _ in
                SPIndicatorView(title: "Long action", preset: .done).present()
            },
            UIAction(
                title: "Action with icon",
                image: UIImage(systemName: "star")
            ) { _ in
                SPIndicatorView(title: "Icon action", preset: .done).present()
            },
        ]))

        let iconAlignmentMenu: Menu = .init(title: "Icon Alignment Test", menu: .init(children: [
            UIAction(
                title: "Single line with icon",
                image: UIImage(systemName: "star.fill")
            ) { _ in
                SPIndicatorView(title: "Single line icon", preset: .done).present()
            },
            UIAction(
                title: "Multi-line text with icon that spans multiple lines to test vertical centering",
                image: UIImage(systemName: "heart.fill")
            ) { _ in
                SPIndicatorView(title: "Multi-line icon", preset: .done).present()
            },
            UIAction(
                title: "Short",
                image: UIImage(systemName: "circle.fill")
            ) { _ in
                SPIndicatorView(title: "Short icon", preset: .done).present()
            },
        ]))

        let multiLineTextMenu: Menu = .init(title: "Multi-line Text Test", menu: .init(children: [
            UIAction(title: "Single line text") { _ in
                SPIndicatorView(title: "Single line", preset: .done).present()
            },
            UIAction(title: "Two line text that wraps to the next line for proper testing") { _ in
                SPIndicatorView(title: "Two lines", preset: .done).present()
            },
            UIAction(title: "Very long text that should wrap across multiple lines to test the layout and vertical centering properly") { _ in
                SPIndicatorView(title: "Multi-line", preset: .done).present()
            },
            UIAction(
                title: "Multi-line with icon that should be vertically centered",
                image: UIImage(systemName: "text.alignleft")
            ) { _ in
                SPIndicatorView(title: "Multi-line icon", preset: .done).present()
            },
        ]))

        let responsiveWidthMenu: Menu = .init(title: "Responsive Width Test", menu: .init(children: [
            UIAction(title: "Normal width item") { _ in
                SPIndicatorView(title: "Normal", preset: .done).present()
            },
            UIAction(title: "Very long item that tests the min(max(width) + 32, available - 64) formula") { _ in
                SPIndicatorView(title: "Long formula test", preset: .done).present()
            },
            UIAction(
                title: "Item with icon and long text",
                image: UIImage(systemName: "arrow.right")
            ) { _ in
                SPIndicatorView(title: "Icon + long", preset: .done).present()
            },
            UIAction(
                title: "Short",
                image: UIImage(systemName: "checkmark")
            ) { _ in
                SPIndicatorView(title: "Short icon", preset: .done).present()
            },
        ]))

        let customWidthMenu: Menu = .init(title: "Custom Width Test", menu: .init(children: [
            UIAction(title: "This menu uses custom width") { _ in
                SPIndicatorView(title: "Custom width", preset: .done).present()
            },
            UIAction(title: "Set to 350 points") { _ in
                SPIndicatorView(title: "350 width", preset: .done).present()
            },
        ]))

        var menuList: [Menu] { [
            firstMenu,
            secondMenu,
            veryLongMenu,
            deferredMenuElement,
            productionTest,
            longTextTest,
            backportMenu,
            attributesMenu,
            keepsMenuPresentedMenu,
            dynamicWidthMenu,
            iconAlignmentMenu,
            multiLineTextMenu,
            responsiveWidthMenu,
            customWidthMenu,
        ] }

        func numberOfSections(in _: UITableView) -> Int {
            1
        }

        func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
            menuList.count
        }

        func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            let menu = menuList[indexPath.row]
            cell.textLabel?.text = menu.title
            cell.accessoryType = .disclosureIndicator
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            let anchorView = UIView()
            cell.addSubview(anchorView)
            anchorView.frame = .init(
                x: cell.bounds.midX,
                y: cell.bounds.midY,
                width: 0,
                height: 0
            )
            let menu = menuList[indexPath.row].menu

            // Configure custom width for the custom width test menu
            if menuList[indexPath.row].title == "Custom Width Test" {
                ChidoriMenuConfiguration.suggestedWidth = 350
            } else {
                ChidoriMenuConfiguration.suggestedWidth = nil
            }

            anchorView.present(menu: menu)
            anchorView.removeFromSuperview()
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection _: Int) -> UIView? {
            let view = UIView()
            view.frame = .init(x: 0, y: 0, width: tableView.bounds.width, height: 20)
            return view
        }
    }

    func makeUIViewController(context _: Context) -> ContentController {
        ContentController()
    }

    func updateUIViewController(_: ContentController, context _: Context) {}
}

class FooterButton: UIButton {
    init() {
        super.init(frame: .init(x: 0, y: 0, width: 200, height: 44))
        setTitle("Test Menu", for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = .preferredFont(forTextStyle: .footnote)

        interactions = [UIContextMenuInteraction(delegate: self)]

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    @objc func buttonTapped() {
        presentMenu()
    }

    override func contextMenuInteraction(_: UIContextMenuInteraction, configurationForMenuAtLocation _: CGPoint) -> UIContextMenuConfiguration? {
        .init(identifier: nil, previewProvider: nil) { items in
            .init(title: "Hello World", children: items + [UIAction(title: "Action A") { _ in
                SPIndicator.present(title: "Action A", haptic: .success)
            }])
        }
    }
}
