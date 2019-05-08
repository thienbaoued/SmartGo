//
//  HomeViewController.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit
import LNSideMenu

class HomeViewController: BaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNav()
  }
  
  @IBAction func signIn(_ sender: Any) {
    let vc = Helper.getViewController(named: SignInViewController.identifier, inSb: Storyboard.signin.rawValue) as! SignInViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  override func setupNav() {
    super.setupNav()
    
    // Create and add menu button to left view
    setupButtonForMenu()
    // Set navigation bar translucent style
    self.navigationBarTranslucentStyle()
    // Update side menu
    sideMenuManager?.instance()?.menu?.isNavbarHiddenOrTransparent = true
    // Re-enable sidemenu
    sideMenuManager?.instance()?.menu?.disabled = false
  }
}

extension HomeViewController {
  
  func setupButtonForMenu() {
    let menuButton = createBarButtonItem(action: #selector(showMenu), image: Icons.menu, title: nil, insets: UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0))
    
    addLeftRightButton(button: menuButton, pos: .left)
  }
  
  
  
  @objc func showMenu() {
    sideMenuManager?.toggleSideMenuView()
  }
  
}

