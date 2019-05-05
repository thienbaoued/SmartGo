//
//  UIHelper.swift
//  Timo
//
//  Copyright © 2018 Timo. All rights reserved.
//

import SVProgressHUD

class UIHelper:NSObject {
  
  class func showLoading(_ message: String = "Please wait.") {
    OperationQueue.main.addOperation { () in
      SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
      SVProgressHUD.show(withStatus: message)
    }
  }
  
  class func hideLoading() {
    OperationQueue.main.addOperation { () in
      SVProgressHUD.dismiss()
    }
  }
}
