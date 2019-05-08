//
//  MenuViewController.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit
import ServiceFlatform

protocol MenuDelegate: class {
  func didSelectItemAtIndex(index idx: Int)
}

class MenuViewController: UIViewController, ReuseIdentifier {

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet var menuView: UIView!
  @IBOutlet weak var profileView: UIView!
  @IBOutlet weak var menuTableView: UITableView!
  
  weak var delegate: MenuDelegate?
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    defaultProfileData()
    setupMenuTableView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupUI()
  }
}

extension MenuViewController {
  
  private func setupUI() {
    setupUIProfile()
    setupUIMenu()
    setupAvatarImage()
  }
  
  private func setupUIProfile() {
    addBorderForProfileView()
  }
  
  private func setupUIMenu() {
    cornerMenuView()
  }
  
  private func addBorderForProfileView() {
    profileView.makeShadow()
  }
  
  private func cornerMenuView() {
    menuView.layer.cornerRadius = 40
    menuView.layer.masksToBounds = true
    menuView.clipsToBounds = true
  }
  
  private func setupAvatarImage() {
    avatarImage.cornerAndShadow()
  }
  
}

extension MenuViewController {
  
  private func defaultProfileData() {
    avatarImage.image = Icons.user
  }
  
//  private func updateProfileData(for user: User) {
//    avatarImage.loadImageFromURL(user.imageURL)
//    //nameUserLabel.text = user.name
//  }
}

extension MenuViewController {
  
  private func registerCell() {
    menuTableView.register(MenuItemCell.nib, forCellReuseIdentifier: MenuItemCell.identifier)
  }
  
  private func setupMenuTableView() {
    registerCell()
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
}
