//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by artem on 03.01.2024.
//

import UIKit
import ProgressHUD
import Kingfisher

final class ProfileViewController: UIViewController {
    private enum Const {
        static let imageViewSide: CGFloat = 70
        static let imageViewTopOffset: CGFloat = 20
        static let imageViewLeadingOffset: CGFloat = 20
        static let nameLabelTopOffset: CGFloat = 8
        static let loginLabelTopOffset: CGFloat = 8
        static let descriptionLabelTopOffset: CGFloat = 8
        static let logoutButtonTrailingOffset: CGFloat = 20
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private let imageView: UIImageView = {
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = nameLabel.font.withSize(23)
        return nameLabel
    }()
    
    private let loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = .gray
        loginLabel.font = loginLabel.font.withSize(13)
        return loginLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .white
        descriptionLabel.font = descriptionLabel.font.withSize(13)
        return descriptionLabel
    }()
    
    private let logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        return logoutButton
    }()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupConstraints()
        updateProfile()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: profileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.downloadAvatar()
        }
        downloadAvatar()
    }
    
    // MARK: - Initial setup
    private func setupConstraints() {
        view.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: Const.imageViewSide).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Const.imageViewSide).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Const.imageViewTopOffset).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Const.imageViewLeadingOffset).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Const.imageViewSide * 0.5
        imageView.contentMode = .scaleAspectFill
        
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Const.nameLabelTopOffset).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
        view.addSubview(loginLabel)
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Const.loginLabelTopOffset).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: Const.descriptionLabelTopOffset).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
        
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Const.logoutButtonTrailingOffset).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    private func updateProfile() {
        guard let profile = profileService.currentProfile else { return }
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func downloadAvatar() {
        guard let avatarURL = profileImageService.avatarURL else { return }
        DispatchQueue.main.async {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: avatarURL)
        }
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        descriptionLabel.removeFromSuperview()
    }
}
