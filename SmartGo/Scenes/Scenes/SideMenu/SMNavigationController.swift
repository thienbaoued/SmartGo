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
    let vc = UIStoryboard(name: Storyboard.menu.rawValue, bundle: nil).instantiateViewController(withIdentifier: MenuViewController.identifier) as! MenuViewController
    //vc.delegate = self
    menu = LNSideMenu(navigation: self, menuPosition: position, customSideMenu: vc, size: .custom(UIScreen.main.bounds.width - 75))
    menu?.delegate = self
    menu?.enableDynamic = true
  }
}

extension SMNavigationController: LNSideMenuDelegate {
  func sideMenuWillOpen() {
    print("sideMenuWillOpen")
  }
  
  func sideMenuWillClose() {
    print("sideMenuWillClose")
  }
  
  func sideMenuDidClose() {
    print("sideMenuDidClose")
  }
  
  func sideMenuDidOpen() {
    print("sideMenuDidOpen")
  }
  
  func didSelectItemAtIndex(_ index: Int) {
    //setContentVC(index)
  }
}
