//
//  ImagePicker.swift
//  RxExample-iOS
//
//  Copyright © 2018 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public struct ImagePicker {
  
  public weak var vc: UIViewController?
  public func getImage(action: Driver<Void>, editable: Bool = true) -> (PublishSubject<UIImage?>, Disposable) {
    let complete = PublishSubject<UIImage?>()
    let disposable = action.flatMapLatest { _ in
      return self.promptFor(alert: UIAlertController(title: nil,
                                                     message: nil,
                                                     preferredStyle: .actionSheet),
                                                     cancelAction: Action.Cancel("Cancel"),
                                                     actions: [Action.ScanImage("Take photo"), Action.UploadImage("Choose photo")])
        .map{$0}.asDriver(onErrorJustReturn: .Cancel("Cancel"))
      }.drive(onNext: { (action) in
        switch action {
        case .UploadImage:
          _ = UIImagePickerController.rx.createWithParent(self.vc) { picker in
            picker.sourceType = .photoLibrary
            picker.allowsEditing = editable
            }.subscribeOn(MainScheduler.instance)
            .flatMapLatest { $0.rx.didFinishPickingMediaWithInfo }
            .take(1)
            .map {
              $0[editable ? convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage) : convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
            }
            .subscribe(onNext: { (img) in
              complete.onNext(img)
            })
        case .Cancel:break
        case .ScanImage:
          _ = UIImagePickerController.rx.createWithParent(self.vc) { picker in
            picker.sourceType = .camera
            picker.allowsEditing = editable
            }.subscribeOn(MainScheduler.instance)
            .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            .take(1)
            .map { $0[editable ? convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage) : convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage }
            .subscribe(onNext: { (img) in
              complete.onNext(img)
            })
        }
      })
    return (complete, disposable)
  }
  
  
  public func promptFor<Action : CustomStringConvertible>(alert: UIAlertController,
                                                          cancelAction: Action, actions: [Action]) -> Observable<Action> {
    
    return Observable.create { observer in
      
      alert.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
        observer.on(.next(cancelAction))
      })
      
      for action in actions {
        alert.addAction(UIAlertAction(title: action.description, style: .default) { _ in
          observer.on(.next(action))
        })
      }
      self.vc?.present(alert, animated: true, completion: nil)
      return Disposables.create {
        alert.dismiss(animated: false, completion: nil)
      }
    }
  }
  
  public enum Action: CustomStringConvertible {
    case Cancel(String)
    case ScanImage(String)
    case UploadImage(String)
    public var description: String {
      switch self {
      case .Cancel(let title): return title
      case .ScanImage(let title): return title
      case .UploadImage(let title): return title
      }
    }
  }
  
  static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
