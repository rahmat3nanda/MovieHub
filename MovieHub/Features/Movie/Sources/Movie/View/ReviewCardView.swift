import UIKit
import DomainKit
import DesignSystem
import Kingfisher
import UtilityKit

final class ReviewCardView: UIView {

    private let avatarView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 22
        view.backgroundColor = UIColor.secondary.withAlphaComponent(0.3)
        view.image = UIImage(systemName: "person.fill")
        view.tintColor = .secondary
        return view
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        return label
    }()

    private let ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 3
        stack.alignment = .center
        return stack
    }()

    private let starIcon: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "star.fill"))
        view.tintColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.numberOfLines = 5
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .systemGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.05)
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.border.cgColor

        ratingStack.addArrangedSubview(starIcon)
        ratingStack.addArrangedSubview(ratingLabel)
        starIcon.anchors.size.equal(CGSize(width: 12, height: 12))

        let headerRight = UIStackView(arrangedSubviews: [authorLabel, usernameLabel, ratingStack])
        headerRight.axis = .vertical
        headerRight.spacing = 2
        headerRight.alignment = .leading

        let headerStack = UIStackView(arrangedSubviews: [avatarView, headerRight])
        headerStack.axis = .horizontal
        headerStack.spacing = 10
        headerStack.alignment = .center
        avatarView.anchors.size.equal(CGSize(width: 44, height: 44))

        let mainStack = UIStackView(arrangedSubviews: [headerStack, contentLabel, dateLabel])
        mainStack.axis = .vertical
        mainStack.spacing = 10

        addSubview(mainStack)
        mainStack.anchors.edges.pin(insets: UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14))
    }

    func configure(with review: MovieReview) {
        authorLabel.text = review.author.isEmpty ? review.authorDetails.username : review.author
        usernameLabel.text = "@\(review.authorDetails.username)"

        if let rating = review.authorDetails.rating {
            ratingStack.isHidden = false
            ratingLabel.text = String(format: "%.1f", rating)
        } else {
            ratingStack.isHidden = true
        }

        contentLabel.text = review.content

        // Parse date
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: review.createdAt) {
            let display = DateFormatter()
            display.dateStyle = .medium
            dateLabel.text = display.string(from: date)
        } else {
            dateLabel.text = review.createdAt
        }

        // Avatar
        if let avatarPath = review.authorDetails.avatarPath {
            let cleaned = avatarPath.hasPrefix("/https://") ? String(avatarPath.dropFirst()) :
                          avatarPath.hasPrefix("/http://") ? String(avatarPath.dropFirst()) :
                          "https://image.tmdb.org/t/p/w200\(avatarPath)"
            if let url = URL(string: cleaned) {
                avatarView.kf_setImage(with: url)
            }
        }
    }
}

private extension UIImageView {
    func kf_setImage(with url: URL) {
        kf.setImage(with: url, options: [.transition(.fade(0.25)), .cacheOriginalImage])
    }
}
