import SwiftUI
import UIKit

public struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    private let builder: () -> ViewController

    public init(_ builder: @escaping () -> ViewController) {
        self.builder = builder
    }

    public func makeUIViewController(context: Context) -> ViewController {
        builder()
    }

    public func updateUIViewController(
        _ uiViewController: ViewController,
        context: Context
    ) { }
}

public struct UIViewPreview<View: UIView>: UIViewRepresentable {
    private let builder: () -> View

    public init(_ builder: @escaping () -> View) {
        self.builder = builder
    }

    public func makeUIView(context: Context) -> View {
        builder()
    }

    public func updateUIView(
        _ uiView: View,
        context: Context
    ) { }
}
