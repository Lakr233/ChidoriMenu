//
//  ProductionExamples.swift
//  ChidoriMenuExample
//
//  Created by 秋星桥 on 1/19/25.
//

import ChidoriMenu
import SPIndicator
import UIKit

enum ProductionExamplesTests {
    static let productionMenu: MenuDefinition = .init(
        title: "Production Style Test",
        menu: UIMenu(
            title: NSLocalizedString("Select Model Type", comment: ""),
            options: [.displayInline],
            children: [
                UIMenu(
                    title: NSLocalizedString("Local Model", comment: ""),
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
                        UIMenu(
                            title: NSLocalizedString("Service Providers", comment: ""),
                            options: [.singleSelection],
                            children: [
                                UIAction(title: "OpenAI") { _ in
                                    showIndicator("OpenAI")
                                },
                                UIAction(title: "OpenRouter") { _ in
                                    showIndicator("OpenRouter")
                                },
                                UIAction(title: "DeepSeek") { _ in
                                    showIndicator("DeepSeek")
                                },
                                UIAction(title: "Groq") { _ in
                                    showIndicator("Groq")
                                },
                            ]
                        ),
                    ]
                ),
            ]
        )
    )

    static let documentMenu: MenuDefinition = .init(
        title: "Document Actions",
        menu: .init(title: "Document", children: [
            UIAction(
                title: "New Document",
                image: UIImage(systemName: "doc.badge.plus")
            ) { _ in
                showIndicator("New Document")
            },
            UIAction(
                title: "Open",
                image: UIImage(systemName: "folder")
            ) { _ in
                showIndicator("Open")
            },
            UIMenu(
                title: "Recent Documents",
                image: UIImage(systemName: "clock"),
                children: [
                    UIAction(title: "Document 1.txt") { _ in
                        showIndicator("Document 1")
                    },
                    UIAction(title: "Document 2.txt") { _ in
                        showIndicator("Document 2")
                    },
                    UIAction(title: "Document 3.txt") { _ in
                        showIndicator("Document 3")
                    },
                ]
            ),
            UIMenu(
                title: "Export",
                image: UIImage(systemName: "square.and.arrow.up"),
                options: [.displayInline],
                children: [
                    UIAction(
                        title: "PDF",
                        image: UIImage(systemName: "doc.richtext")
                    ) { _ in
                        showIndicator("Export PDF")
                    },
                    UIAction(
                        title: "Word",
                        image: UIImage(systemName: "doc")
                    ) { _ in
                        showIndicator("Export Word")
                    },
                    UIAction(
                        title: "Plain Text",
                        image: UIImage(systemName: "doc.plaintext")
                    ) { _ in
                        showIndicator("Export Text")
                    },
                ]
            ),
        ])
    )

    static let mediaPlayerMenu: MenuDefinition = .init(
        title: "Media Player Controls",
        menu: .init(title: "Playback", children: [
            UIAction(
                title: "Play",
                image: UIImage(systemName: "play.fill")
            ) { _ in
                showIndicator("Play")
            },
            UIAction(
                title: "Pause",
                image: UIImage(systemName: "pause.fill")
            ) { _ in
                showIndicator("Pause")
            },
            UIAction(
                title: "Stop",
                image: UIImage(systemName: "stop.fill")
            ) { _ in
                showIndicator("Stop")
            },
            UIMenu(
                title: "Playback Speed",
                image: UIImage(systemName: "speedometer"),
                options: [.displayInline, .singleSelection],
                children: [
                    UIAction(title: "0.5x", state: .off) { _ in
                        showIndicator("0.5x speed")
                    },
                    UIAction(title: "1x", state: .on) { _ in
                        showIndicator("Normal speed")
                    },
                    UIAction(title: "1.5x", state: .off) { _ in
                        showIndicator("1.5x speed")
                    },
                    UIAction(title: "2x", state: .off) { _ in
                        showIndicator("2x speed")
                    },
                ]
            ),
            UIMenu(
                title: "Audio",
                image: UIImage(systemName: "speaker.wave.2"),
                children: [
                    UIAction(
                        title: "Increase Volume",
                        image: UIImage(systemName: "speaker.wave.2")
                    ) { _ in
                        showIndicator("Volume Up")
                    },
                    UIAction(
                        title: "Decrease Volume",
                        image: UIImage(systemName: "speaker.wave.1")
                    ) { _ in
                        showIndicator("Volume Down")
                    },
                    UIAction(
                        title: "Mute",
                        image: UIImage(systemName: "speaker.slash")
                    ) { _ in
                        showIndicator("Mute")
                    },
                ]
            ),
        ])
    )

    static let allExamples: [MenuDefinition] = [
        productionMenu,
        documentMenu,
        mediaPlayerMenu,
    ]
}

private func showIndicator(_ message: String) {
    SPIndicatorView(title: message, preset: .done).present()
}
