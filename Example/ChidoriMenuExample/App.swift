//
//  App.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
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
            view.addSubview(tableView)
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            tableView.frame = view.bounds
        }

        struct Menu {
            let title: String
            let menu: UIMenu
        }

        let menuList: [Menu] = [
            .init(title: "Default Preset", menu: .init(children: [
                UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
                    print("Copy")
                },
            ])),
        ]

        func numberOfSections(in _: UITableView) -> Int {
            1
        }

        func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
            menuList.count
        }

        func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            let menu = menuList[indexPath.section]
            cell.textLabel?.text = menu.title
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.present(menu: menuList[indexPath.section].menu)
        }
    }

    func makeUIViewController(context _: Context) -> ContentController {
        ContentController()
    }

    func updateUIViewController(_: ContentController, context _: Context) {}
}
