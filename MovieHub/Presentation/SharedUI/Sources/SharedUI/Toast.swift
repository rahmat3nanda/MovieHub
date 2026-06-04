//
//  Toast.swift
//  SharedUI
//
//  Created by Antigravity on 04/06/26.
//

import UIKit
import UtilityKit

public enum ToastType {
    case success
    case error
    case warning
    case info
}

public protocol ToastService {
    /// Shows a toast message overlay at the top of the key window.
    /// - Parameters:
    ///   - message: The message text to display.
    ///   - type: The toast style (success, error, warning, info).
    ///   - duration: The duration in seconds before auto-dismissing. Defaults to 2.5.
    func show(message: String, type: ToastType, duration: TimeInterval)
}

public extension ToastService {
    func show(message: String, type: ToastType = .info, duration: TimeInterval = 2.5) {
        show(message: message, type: type, duration: duration)
    }
}

public final class DefaultToastService: ToastService {
    public init() {}
    
    public func show(message: String, type: ToastType, duration: TimeInterval) {
        DispatchQueue.main.async {
            guard let window = self.keyWindow else { return }
            
            // Dismiss any active toast views to avoid stacking overlaps
            window.subviews.compactMap { $0 as? ToastView }.forEach { $0.dismiss() }
            
            let toast = ToastView(message: message, type: type)
            window.addSubview(toast)
            
            toast.translatesAutoresizingMaskIntoConstraints = false
            
            // Set the start constraint off-screen above the safe area
            let topConstraint = toast.topAnchor.constraint(equalTo: window.topAnchor, constant: -120)
            
            NSLayoutConstraint.activate([
                topConstraint,
                toast.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                toast.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 16),
                toast.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -16),
                toast.widthAnchor.constraint(lessThanOrEqualToConstant: 420)
            ])
            
            window.layoutIfNeeded()
            
            // Slide down with a nice spring animation below the safe area
            let topOffset = window.safeAreaInsets.top + 12
            topConstraint.constant = topOffset
            
            UIView.animate(
                withDuration: 0.45,
                delay: 0,
                usingSpringWithDamping: 0.75,
                initialSpringVelocity: 0.6,
                options: .beginFromCurrentState
            ) {
                window.layoutIfNeeded()
            } completion: { _ in
                // Schedule dismissal
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    toast.dismiss()
                }
            }
        }
    }
    
    private var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

public final class ToastView: UIView {
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    public init(message: String, type: ToastType) {
        super.init(frame: .zero)
        setupUI(message: message, type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(message: String, type: ToastType) {
        // Configure shadow on wrapper, keeps clipsToBounds = false
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.18
        
        // Setup blur background with rounded corners
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.borderWidth = 1.0 / UIScreen.main.scale
        blurEffectView.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        
        addSubview(blurEffectView)
        blurEffectView.anchors.edges.pin()
        
        messageLabel.text = message
        configureType(type)
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(messageLabel)
        
        blurEffectView.contentView.addSubview(stackView)
        
        iconImageView.anchors.size.equal(CGSize(width: 20, height: 20))
        stackView.anchors.edges.pin(insets: UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18))
    }
    
    private func configureType(_ type: ToastType) {
        switch type {
        case .success:
            iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
            iconImageView.tintColor = .systemGreen
        case .error:
            iconImageView.image = UIImage(systemName: "xmark.circle.fill")
            iconImageView.tintColor = .systemRed
        case .warning:
            iconImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            iconImageView.tintColor = .systemOrange
        case .info:
            iconImageView.image = UIImage(systemName: "info.circle.fill")
            iconImageView.tintColor = .systemBlue
        }
    }
    
    public func dismiss() {
        guard let superview = self.superview else { return }
        
        // Animate top constraint back off-screen
        if let topConstraint = superview.constraints.first(where: {
            ($0.firstItem as? UIView) == self && $0.firstAttribute == .top
        }) {
            topConstraint.constant = -120
            
            UIView.animate(withDuration: 0.35, animations: {
                superview.layoutIfNeeded()
                self.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0.0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}
