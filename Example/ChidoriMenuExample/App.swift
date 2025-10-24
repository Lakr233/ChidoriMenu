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
                .background(Color(UIColor.systemBackground).ignoresSafeArea())
                .ignoresSafeArea()
                .navigationTitle("Chidori Menu")
        }
        .navigationViewStyle(.stack)
    }
}

struct Content: UIViewControllerRepresentable {
    class ContentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        private enum Section: Int, CaseIterable {
            case menuDefinitions
            case specialCases

            var headerTitle: String? {
                switch self {
                case .menuDefinitions:
                    return nil
                case .specialCases:
                    return "Special Cases"
                }
            }
        }

        private struct SpecialCase {
            let title: String
            let buildController: () -> UIViewController
        }

        private let cellIdentifier = "ContentCell"
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        private let specialCases: [SpecialCase] = [
            .init(title: "Scroll Trigger Menu") {
                ScrollMenuOnScrollViewController()
            },
        ]

        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
            view.addSubview(tableView)

            ChidoriMenuConfiguration.accentColor = .systemPink
            ChidoriMenuConfiguration.backgroundColor = .systemBackground
            ChidoriMenuConfiguration.prefersLiquidGlass = true
            ChidoriMenuConfiguration.glassTintColor = nil // Use default tint
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            tableView.frame = view.bounds
        }

        func numberOfSections(in _: UITableView) -> Int {
            Section.allCases.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let section = Section(rawValue: section) else { return 0 }
            switch section {
            case .menuDefinitions:
                return MenuRegistry.allMenus.count
            case .specialCases:
                return specialCases.count
            }
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default

            guard let section = Section(rawValue: indexPath.section) else { return cell }
            switch section {
            case .menuDefinitions:
                let menu = MenuRegistry.allMenus[indexPath.row]
                cell.textLabel?.text = menu.title
                cell.textLabel?.textColor = .label
            case .specialCases:
                let specialCase = specialCases[indexPath.row]
                cell.textLabel?.text = specialCase.title
                cell.textLabel?.textColor = .label
            }

            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            guard let section = Section(rawValue: indexPath.section) else { return }

            switch section {
            case .menuDefinitions:
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

                // Configure liquid glass tint for the liquid glass menu
                if menuDefinition.title == "Liquid Glass Menu" {
                    ChidoriMenuConfiguration.glassTintColor = .systemBlue.withAlphaComponent(0.5)
                } else {
                    ChidoriMenuConfiguration.glassTintColor = nil
                }

                anchorView.present(menu: menuDefinition.menu)
                anchorView.removeFromSuperview()

            case .specialCases:
                let builder = specialCases[indexPath.row].buildController
                let controller = builder()
                navigationController?.pushViewController(controller, animated: true)
            }
        }

        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard let section = Section(rawValue: section) else { return nil }
            switch section {
            case .menuDefinitions:
                let spacer = UIView()
                spacer.backgroundColor = .clear
                return spacer
            case .specialCases:
                guard let title = section.headerTitle else { return nil }
                let container = UIView()
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = title
                label.font = .preferredFont(forTextStyle: .headline)
                label.textColor = .secondaryLabel
                container.addSubview(label)

                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
                    label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
                    label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
                    label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
                ])

                return container
            }
        }

        func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            guard let section = Section(rawValue: section) else { return 0 }
            switch section {
            case .menuDefinitions:
                return 20
            case .specialCases:
                return 44
            }
        }
    }

    func makeUIViewController(context _: Context) -> ContentController {
        ContentController()
    }

    func updateUIViewController(_: ContentController, context _: Context) {}
}
