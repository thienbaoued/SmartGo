//
//  SMNavigationController.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit
import LNSideMenu

class SMNavigationController: LNSideMenuNavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    initialCustomMenu(position: .left)
  }
  
  fileprivate func initialCustomMenu(position: Position) {
    let vc = Helper.getViewController(named: MenuViewController.identifier, inSb: Storyboard.menu.rawValue) as! MenuViewController
    vc.delegate = self
    menu = LNSideMenu(navigation: self, menuPosition: position, customSideMenu: vc, size: .custom(UIScreen.main.bounds.width - 75))
    menu?.enableDynamic = true
  }
}

extension SMNavigationController: SideMenuDelegate {
  func didSelectProfile() {
    menu?.hideSideMenu()
    print("Profile")
  }

  func didSelectItem(item: String) {
    menu?.hideSideMenu()
    guard let item = MenuItems(rawValue: item) else { return }
    switch item {
    case .notification, .contact, .mode, .setting, .sound:
      print(item.rawValue)
    default:
      FirebaseAuthManger.shared.signOut()
      let vc = Helper.getViewController(named: SignInViewController.identifier, inSb: Storyboard.signin.rawValue) as! SignInViewController
      self.pushViewController(vc, animated: true)
    }
  }
}
