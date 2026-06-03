import UIKit
import DesignSystem
import SharedUI
import UtilityKit

public final class ProfileViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.text = "Profile"
        return label
    }()
    
    // MARK: - Avatar Section
    private let profileCard: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6.withAlphaComponent(0.15)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "Rahmat Trinanda"
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13)
        label.text = "rahmat3nanda@gmail.com"
        return label
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow
        label.backgroundColor = .systemYellow.withAlphaComponent(0.15)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemYellow.cgColor
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.text = " PRO MEMBER "
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Stats Section
    private let statsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Settings List
    private let settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.isScrollEnabled = false
        return table
    }()
    
    private let settingsOptions = [
        ("Watchlist", "bookmark.fill"),
        ("Account Settings", "person.fill"),
        ("Notifications", "bell.fill"),
        ("Theme Preferences", "paintpalette.fill"),
        ("Privacy & Security", "lock.shield.fill")
    ]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
        loadStats()
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.background
        
        view.addSubview(titleLabel)
        view.addSubview(profileCard)
        profileCard.addSubview(avatarImageView)
        profileCard.addSubview(nameLabel)
        profileCard.addSubview(emailLabel)
        profileCard.addSubview(badgeLabel)
        
        view.addSubview(statsStack)
        view.addSubview(settingsTable)
        
        // Constraints
        titleLabel.anchors.top.pin(to: view.safeAreaLayoutGuide.topAnchor, inset: 16)
        titleLabel.anchors.leading.pin(inset: 16)
        titleLabel.anchors.trailing.pin(inset: 16)
        
        // Profile Card
        profileCard.anchors.top.spacing(20, to: titleLabel.anchors.bottom)
        profileCard.anchors.leading.pin(inset: 16)
        profileCard.anchors.trailing.pin(inset: 16)
        profileCard.anchors.height.equal(110)
        
        avatarImageView.anchors.leading.pin(inset: 16)
        avatarImageView.anchors.centerY.align()
        avatarImageView.anchors.size.equal(CGSize(width: 80, height: 80))
        
        nameLabel.anchors.top.pin(to: avatarImageView.anchors.top, inset: 6)
        nameLabel.anchors.leading.spacing(16, to: avatarImageView.anchors.trailing)
        nameLabel.anchors.trailing.pin(inset: 16)
        
        emailLabel.anchors.top.spacing(4, to: nameLabel.anchors.bottom)
        emailLabel.anchors.leading.spacing(16, to: avatarImageView.anchors.trailing)
        emailLabel.anchors.trailing.pin(inset: 16)
        
        badgeLabel.anchors.top.spacing(8, to: emailLabel.anchors.bottom)
        badgeLabel.anchors.leading.spacing(16, to: avatarImageView.anchors.trailing)
        badgeLabel.anchors.height.equal(18)
        badgeLabel.anchors.width.equal(90)
        
        // Stats Stack
        statsStack.anchors.top.spacing(20, to: profileCard.anchors.bottom)
        statsStack.anchors.leading.pin(inset: 16)
        statsStack.anchors.trailing.pin(inset: 16)
        statsStack.anchors.height.equal(60)
        
        // Table View
        settingsTable.anchors.top.spacing(20, to: statsStack.anchors.bottom)
        settingsTable.anchors.leading.pin()
        settingsTable.anchors.trailing.pin()
        settingsTable.anchors.bottom.pin(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func setupTable() {
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }
    
    private func loadStats() {
        let stats = [("120", "Watched"), ("42", "Favorites"), ("15", "Reviews")]
        for stat in stats {
            let container = UIView()
            container.backgroundColor = .systemGray6.withAlphaComponent(0.15)
            container.layer.cornerRadius = 12
            container.layer.masksToBounds = true
            container.layer.borderWidth = 1
            container.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
            
            let countLabel = UILabel()
            countLabel.textColor = .label
            countLabel.text = stat.0
            countLabel.font = .systemFont(ofSize: 18, weight: .bold)
            countLabel.textAlignment = .center
            
            let descLabel = UILabel()
            descLabel.textColor = .secondaryLabel
            descLabel.text = stat.1
            descLabel.font = .systemFont(ofSize: 11)
            descLabel.textAlignment = .center
            
            container.addSubview(countLabel)
            container.addSubview(descLabel)
            
            countLabel.translatesAutoresizingMaskIntoConstraints = false
            descLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                countLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
                countLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                
                descLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 2),
                descLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                descLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
            ])
            
            statsStack.addArrangedSubview(container)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.backgroundColor = .systemGray6.withAlphaComponent(0.12)
        cell.textLabel?.textColor = .label
        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        
        let item = settingsOptions[indexPath.row]
        cell.textLabel?.text = item.0
        cell.imageView?.image = UIImage(systemName: item.1)
        cell.imageView?.tintColor = .systemYellow
        cell.accessoryType = .disclosureIndicator
        
        // Selection style background
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        cell.selectedBackgroundView = selectionView
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
