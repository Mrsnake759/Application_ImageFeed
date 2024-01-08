//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by artem on 03.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBAction func didTapLogoutButton() {
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var loginNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
}
