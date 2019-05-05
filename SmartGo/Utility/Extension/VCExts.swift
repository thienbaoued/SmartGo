//
//  VCExts.swift
//  Timo
//
//  Copyright © 2018 Timo. All rights reserved.
//

import UIKit
import ServiceFlatform

extension UIViewController {

  func initialButton(title: String, color: UIColor, fontSize: CGFloat = 13, width: CGFloat = 40) -> UIButton {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 30))
    button.setTitle(title, for: .normal)
    button.setTitleColor(color, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    return button
  }

  @discardableResult func addLeftButton(title: String = "", color: UIColor = .black, fontSize: CGFloat = 14, width: CGFloat = 40) -> UIButton {
    let leftItem = initialButton(title: title, color: color, fontSize: fontSize, width: width)
    let barItem = UIBarButtonItem(customView: leftItem)
    navigationItem.leftBarButtonItem = barItem
    return leftItem
  }

  @discardableResult func addRightButton(title: String = "", color: UIColor = .black, fontSize: CGFloat = 14, width: CGFloat = 40) -> UIButton {
    let rightItem = initialButton(title: title, color: color, fontSize: fontSize, width: width)
    let barItem = UIBarButtonItem(customView: rightItem)
    navigationItem.rightBarButtonItem = barItem
    return rightItem
  }

  func showPopup(viewController: UIViewController? = nil, title: String? = nil, message: String, titleButton: String = "OK", handler: ((UIAlertAction) -> Void)? = nil) {

    /// Dismissing the current alertviewcontroller if there is the one visible on the screen
    if let presenting = self.presentingViewController as? UIAlertController {
      presenting.dismiss(animated: false, completion: nil)
    }
    let alertViewController = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: titleButton, style: .default, handler: handler)
    alertViewController.addAction(okAction)

    if let rootViewController = viewController {
      rootViewController.present(alertViewController, animated: true)
    } else {
      self.present(alertViewController, animated: true)
    }
  }

  func setRootController(rootName: String, inSb sb: String, animated: Bool = true) {
    /// Breaking the function of if all conditions are not met
    guard let window = UIApplication.shared.keyWindow, let rootView = window.rootViewController,
      let destView = Helper.getViewController(named: rootName, inSb: sb) else {
        return
    }
    if !animated {
      /// Set root without animation
      window.rootViewController = destView
    } else {
      /// Replacing rootViewController within an animation
      UIView.transition(from: rootView.view, to: destView.view, duration: 0.25, options: .transitionCrossDissolve) { _ in
        window.rootViewController = destView
      }
    }
  }

  func setRootController(viewController: UIViewController, animated: Bool = true) {
    guard let window = UIApplication.shared.keyWindow else { return }
    if animated {
      window.replaceRoot(vc: viewController)
    } else {
      window.rootViewController = viewController
    }
    window.makeKeyAndVisible()
  }
  /// Presenting a viewcontroller from tabbar controller
  ///
  /// - Parameter viewController: destation viewcontroller
  func tabbarPresent(viewController: UIViewController) {
    guard let tabbar = tabBarController else {
      return
    }
    viewController.modalPresentationStyle = .overCurrentContext
    tabbar.present(viewController, animated: false, completion: nil)
  }
}

extension UIWindow {

  func replaceRoot(vc: UIViewController) {
    let snapshotImgView = UIImageView(image: snapshot())
    addSubview(snapshotImgView)
    let dismissCompletion: Action = {
      self.rootViewController = vc
      self.bringSubviewToFront(snapshotImgView)
      snapshotImgView.fadeAnimation(isShow: false, completion: {
        snapshotImgView.removeFromSuperview()
      })
    }
    dismissPresentations(completed: dismissCompletion)
  }

  private func dismissPresentations(completed: @escaping Action) {
    if rootViewController?.presentedViewController != nil {
      rootViewController?.dismiss(animated: false, completion: {
        self.dismissPresentations(completed: completed)
      })
    } else {
      completed()
    }
  }
}
