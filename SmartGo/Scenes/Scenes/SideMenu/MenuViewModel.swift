//
//  MenuViewModel.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import Foundation
import UIKit

class MenuViewModel {
  
  var itemTitles = MenuItems.allCases.map({ $0.rawValue })
  var itemIconColors = MenuItems.allCases.map({$0.color})
  var itemIcons = MenuItemIcons.allCases.map({UIImage(named: $0.rawValue)!.withRenderingMode(.alwaysTemplate)})
  
}
