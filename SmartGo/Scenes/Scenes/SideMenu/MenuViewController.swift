//
//  MenuViewController.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit
import ServiceFlatform

protocol SideMenuDelegate: class {
  func didSelectItem(item: String)
  func didSelectProfile()
}

class MenuViewController: UIViewController, ReuseIdentifier {

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var viewProfileButton: UIButton!
  
  @IBOutlet var menuView: UIView!
  @IBOutlet weak var menuTableView: UITableView!
  
  weak var delegate: SideMenuDelegate?
  let viewModel = MenuViewModel()
  
  var itemTitles: [String] {
    return viewModel.itemTitles
  }
  
  var itemIconColors: [UIColor] {
    return viewModel.itemIconColors
  }
  
  var imageItems: [UIImage] {
    return viewModel.itemIcons
  }
  
  @IBAction func goToProfile(_ sender: Any) {
    delegate?.didSelectProfile()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setupMenuTableView()
    updateUIProfile()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
}

extension MenuViewController {
  
  func updateUIProfile() {
    NotificationCenter.default.addObserver(self, selector: #selector(getCurrentUser), name: Notification.Name.reloadMenu, object: nil)
  }
  
  @objc func getCurrentUser() {
    FirebaseAuthManger.shared.getCurrentUser(completion: { user in
      guard let user = user else { return }
      self.setupUIProfile(user: user)
    })
  }
  
  func setupUIProfile(user: User) {
    if user.lastName.isEmpty && user.firstName.isEmpty {
      nameLabel.text = user.email
    } else {
      nameLabel.text = user.fullName
    }
    avatarImage.image = Icons.user
  }
  
  private func setupUI() {
    setupUIMenu()
  }
  
  private func setupUIMenu() {
    cornerMenuView()
  }
  
  private func cornerMenuView() {
    menuView.layer.cornerRadius = 40
    menuView.layer.masksToBounds = true
    menuView.clipsToBounds = true
  }
  
}

extension MenuViewController {
  
  private func register() {
    menuTableView.register(MenuItemCell.nib, forCellReuseIdentifier: MenuItemCell.identifier)
  }
  
  private func setupMenuTableView() {
    register()
    menuTableView.delegate = self
    menuTableView.dataSource = self
  }
}

extension MenuViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemTitles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let itemTitle = itemTitles[indexPath.row]
    let itemIconColor = itemIconColors[indexPath.row]
    let itemIcon = imageItems[indexPath.row]
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.identifier) as? MenuItemCell else { return UITableViewCell()}
    cell.updateData(image: itemIcon, title: itemTitle, colorIcon: itemIconColor)
    cell.accessoryType = .disclosureIndicator
    return cell
  }
}

extension MenuViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let delegate = delegate else { return }
    let item = itemTitles[indexPath.row]
    delegate.didSelectItem(item: item)
    menuTableView.reloadData()
  }
}

