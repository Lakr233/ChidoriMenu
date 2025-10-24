import ChidoriMenu
import SPIndicator
import UIKit

final class ScrollMenuOnScrollViewController: UIViewController, UIScrollViewDelegate {
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var menuPresentationWorkItem: DispatchWorkItem?
    private var didPresentMenu = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scroll Trigger Menu"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        setupScrollView()
        setupContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didPresentMenu = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelPendingMenuPresentation()
    }

    deinit {
        cancelPendingMenuPresentation()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.backgroundColor = .systemGroupedBackground
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 24, left: 24, bottom: 24, right: 24)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }

    private func setupContent() {
        for index in 1...20 {
            let label = UILabel()
            label.text = "Scrollable Content Row \(index)"
            label.font = .preferredFont(forTextStyle: .body)
            label.numberOfLines = 0
            label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false

            let container = UIView()
            container.backgroundColor = .secondarySystemGroupedBackground
            container.layer.cornerRadius = 12
            container.layer.masksToBounds = true
            container.addSubview(label)

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
                label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            ])

            stackView.addArrangedSubview(container)
        }
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard !didPresentMenu else { return }
        scheduleMenuPresentation(for: scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !didPresentMenu else { return }
        if !decelerate {
            cancelPendingMenuPresentation()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !didPresentMenu else { return }
        cancelPendingMenuPresentation()
    }

    private func scheduleMenuPresentation(for scrollView: UIScrollView) {
        cancelPendingMenuPresentation()

        let workItem = DispatchWorkItem { [weak self, weak scrollView] in
            guard let self, let scrollView else { return }
            self.presentMenu(anchorIn: scrollView)
        }
        menuPresentationWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }

    private func cancelPendingMenuPresentation() {
        menuPresentationWorkItem?.cancel()
        menuPresentationWorkItem = nil
    }

    private func presentMenu(anchorIn scrollView: UIScrollView) {
        guard !didPresentMenu else { return }
        didPresentMenu = true

        var actions: [UIAction] = []
        actions.append(UIAction(title: "Continue Scrolling", image: UIImage(systemName: "arrow.up.and.down")) { _ in
            let indicator = SPIndicatorView(title: "Keep scrolling!", preset: .done)
            indicator.present()
        })
        actions.append(UIAction(title: "Stop Here", image: UIImage(systemName: "pause.circle")) { _ in
            let indicator = SPIndicatorView(title: "Menu dismissed", preset: .done)
            indicator.present()
        })

        let menu = UIMenu(title: "Scroll Interaction", children: actions)

        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        let anchorPoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        scrollView.present(menu: menu, anchorPoint: anchorPoint)
    }
}
