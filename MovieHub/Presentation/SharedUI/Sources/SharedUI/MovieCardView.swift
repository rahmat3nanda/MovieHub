import UIKit
import DesignSystem

public final class MovieCardView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6.withAlphaComponent(0.15)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        return view
    }()
    
    private let posterContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5.withAlphaComponent(0.2)
        view.layer.masksToBounds = true
        return view
    }()
    
    public let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    private let ratingContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(posterContainer)
        posterContainer.addSubview(posterImageView)
        posterContainer.addSubview(ratingContainer)
        ratingContainer.addSubview(ratingLabel)
        containerView.addSubview(infoStack)
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(subtitleLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        posterContainer.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        ratingContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            posterContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
            posterContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            posterContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            posterContainer.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.4),
            
            posterImageView.topAnchor.constraint(equalTo: posterContainer.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: posterContainer.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: posterContainer.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: posterContainer.bottomAnchor),
            
            ratingContainer.topAnchor.constraint(equalTo: posterContainer.topAnchor, constant: 8),
            ratingContainer.trailingAnchor.constraint(equalTo: posterContainer.trailingAnchor, constant: -8),
            ratingContainer.heightAnchor.constraint(equalToConstant: 22),
            ratingContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            ratingLabel.topAnchor.constraint(equalTo: ratingContainer.topAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingContainer.leadingAnchor, constant: 6),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingContainer.trailingAnchor, constant: -6),
            ratingLabel.bottomAnchor.constraint(equalTo: ratingContainer.bottomAnchor),
            
            infoStack.topAnchor.constraint(equalTo: posterContainer.bottomAnchor, constant: 8),
            infoStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            infoStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            infoStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    public func configure(title: String, subtitle: String, rating: String, posterImage: UIImage? = nil, fallbackColor: UIColor = .systemBlue) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        ratingLabel.text = "★ \(rating)"
        
        if let posterImage = posterImage {
            posterImageView.image = posterImage
            posterImageView.backgroundColor = .clear
        } else {
            posterImageView.image = UIImage(systemName: "film")
            posterImageView.backgroundColor = fallbackColor.withAlphaComponent(0.2)
        }
    }
}
