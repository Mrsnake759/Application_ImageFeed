//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by artem on 03.01.2024.
//

import UIKit
import ProgressHUD
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    var animationLayers = Set<CALayer>()
    
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
        let profileImage = UIImage(named: "profilePhoto")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        nameLabel.font = nameLabel.font.withSize(23)
        return nameLabel
    }()
    
    private let loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.textColor = .gray
        loginLabel.font = loginLabel.font.withSize(13)
        return loginLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
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
            self.downloadAndSetAvatar()
        }
        downloadAndSetAvatar()
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
    
    private func downloadAndSetAvatar() {
        addAnimateGradientTo(
            view: imageView,
            frame: CGRect(origin: .zero, size: CGSize(width: 70, height: 70)),
            cornerRadius: 35
        )
        
        guard let avatarURL = profileImageService.avatarURL else { return }
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: avatarURL) { [weak self] _ in
            guard let self = self else { return }
            self.animationLayers.forEach { $0.removeFromSuperlayer() }
            self.animationLayers.removeAll()
        }
    }
    
    private func showEscapeAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let uiAlertNoAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        let uiAlertOkAction = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            OAuth2TokenStorage.token = nil
            self.clean()
            let splashViewController = SplashViewController()
            splashViewController.modalPresentationStyle = .fullScreen
            self.present(splashViewController, animated: true)
            alert.dismiss(animated: true)
        }
        alert.addAction(uiAlertOkAction)
        alert.addAction(uiAlertNoAction)
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        showEscapeAlert()
    }
    
    private func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func addAnimateGradientTo(view: UIView, frame: CGRect, cornerRadius: CGFloat) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius
        gradient.masksToBounds = true
        animationLayers.insert(gradient)
        view.layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
}
