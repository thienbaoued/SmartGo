//
//  BaseViewController.swift
//  Timo
//
//  Copyright © 2018 Timo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyBeaver
import LNSideMenu

class BaseViewController: UIViewController {

  var disposeBag = DisposeBag()
  let activityIndicator = UIActivityIndicatorView(style: .gray)
  let screenSize = UIScreen.main.bounds.size

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    print("deinit: \(String(describing: self))")
  }

  func setupNav() {
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.tintColor = .white
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)]
  }
  
  func setupLargeNav() {
    if #available(iOS 11.0, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
      navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
      navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)]
      navigationController?.navigationBar.isTranslucent = false
      navigationController?.navigationBar.tintColor = .white
      navigationItem.hidesSearchBarWhenScrolling = true
    }
  }
  
  func addLeftRightButton(button: UIBarButtonItem, pos: Position) {
    if pos == .left {
      navigationItem.leftBarButtonItem = button
    } else {
      navigationItem.rightBarButtonItem = button
    }
  }
  
  func setupBackButton() {
    let barButton = createBarButtonItem(action: #selector(popViewControler), image: Icons.back, insets: UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0))
    navigationItem.leftBarButtonItem = barButton
  }
  
  func setupDismissButton() {
    let barButton = createBarButtonItem(action: #selector(dismissVC), image: Icons.clear, insets: UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0))
    navigationItem.leftBarButtonItem = barButton
  }

  func createBarButtonItem(action: Selector, image: UIImage?=nil, title: String?=nil, insets: UIEdgeInsets?=nil) -> UIBarButtonItem {
    let button = UIButton()
    button.setImage(image ?? nil, for: .normal)
    button.setTitle(title ?? nil, for: .normal)
    button.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
    button.addTarget(self, action: action, for: .touchUpInside)
    button.imageView?.contentMode = .scaleAspectFit
    button.contentEdgeInsets = insets ?? .zero
    return UIBarButtonItem.init(customView: button)
  }
  
  @objc func popViewControler() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func dismissVC() {
    self.dismiss(animated: true, completion: nil)
  }
}
