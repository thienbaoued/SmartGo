//
//  HomeViewController.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit
import LNSideMenu
import DZNEmptyDataSet

class HomeViewController: BaseViewController, ReuseIdentifier {
  
  @IBOutlet weak var planTableView: UITableView!
  @IBOutlet weak var addButton: UIButton!
  
  var nameTitles = [String]()
  
  @IBAction func addNewPlan(_ sender: Any) {
    let alert = UIAlertController(title: "Create new plane", message: "Enter your plan name before start", preferredStyle: .alert)
    
    alert.addTextField(configurationHandler: { (textField) in
      textField.placeholder = "Enter your plan"
      textField.borderStyle = .none
    })
    
    let ok = UIAlertAction(title: "Ok", style: .default) { (ok) in
      guard let namePlane = alert.textFields?.first?.text else { return}
      self.appendPlan(named: namePlane)
    }
    
    alert.addAction(ok)
    alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupPlanTableView()
    setupUIAddButton()
    NotificationCenter.default.post(name: Notification.Name.reloadMenu, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNav()
    getCurrentUser()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func setupNav() {
    super.setupNav()
    
    setupButtonForMenu()
    self.navigationBarTranslucentStyle()
    sideMenuManager?.instance()?.menu?.isNavbarHiddenOrTransparent = true
    sideMenuManager?.instance()?.menu?.disabled = false
  }
}

extension HomeViewController {
  func setupUIAddButton() {
    addButton.cornerAndShadow()
    addButton.setImage(Icons.add, for: .normal)
    addButton.roundBorder(radius: addButton.frame.size.height/2, width: 1, color: UIColor.clear.cgColor, corners: .allCorners)
  }
}

extension HomeViewController {
  func getCurrentUser() {
    FirebaseAuthManger.shared.isCurrentUser(completion: { check in
      if !check {
        let vc = Helper.getViewController(named: SignInViewController.identifier, inSb: Storyboard.signin.rawValue) as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: false)
      }
    })
  }
  
  func appendPlan(named: String) {
    nameTitles.append(named)
    planTableView.reloadData()
  }
}

extension HomeViewController {
  func setupPlanTableView() {
    registerCell()
    planTableView.setup(self)
  }
  
  func registerCell() {
    planTableView.register(TripTableViewCell.nib, forCellReuseIdentifier: TripTableViewCell.identifier)
  }
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return nameTitles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let name = nameTitles[indexPath.row]
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.identifier) as? TripTableViewCell else { return UITableViewCell()}
    cell.title = name
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 175
  }
}

extension HomeViewController: DZNEmptyDataSetSource {
  func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    return Icons.trip
  }
  
  func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let text = "No plan"
    let attribs = [
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
      NSAttributedString.Key.foregroundColor: UIColor.darkGray
    ]
    
    return NSAttributedString(string: text, attributes: attribs)
  }
  
  func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    let text = "Click + to start the trip"
    let attribs = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
      NSAttributedString.Key.foregroundColor: UIColor.darkGray
    ]
    
    return NSAttributedString(string: text, attributes: attribs)
  }
}

extension HomeViewController {
  
  func setupButtonForMenu() {
    let menuButton = createBarButtonItem(action: #selector(showMenu), image: Icons.menu, title: nil, insets: UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0))
    addLeftRightButton(button: menuButton, pos: .left)
  }

  @objc func showMenu() {
    sideMenuManager?.showSideMenuView()
  }
}

