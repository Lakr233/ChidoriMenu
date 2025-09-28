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

        func numberOfSections(in _: UITableView) -> Int {
            1
        }

        func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
            MenuRegistry.allMenus.count
        }

        func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            let menu = MenuRegistry.allMenus[indexPath.row]
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

            let menuDefinition = MenuRegistry.allMenus[indexPath.row]

            // Configure custom width for the custom width test menu
            if menuDefinition.title == "Custom Width Test" {
                ChidoriMenuConfiguration.suggestedWidth = 350
            } else {
                ChidoriMenuConfiguration.suggestedWidth = nil
            }

            anchorView.present(menu: menuDefinition.menu)
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
            .init(title: "Context Menu", children: items + [UIAction(title: "Context Action") { _ in
                SPIndicator.present(title: "Context Action", haptic: .success)
            }])
        }
    }
}
