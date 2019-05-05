//
//  IndentifierCell.swift
//  Cheers
//
//  Created by An on 2018/03/05.
//  Copyright © 2018 Neolab. All rights reserved.
//

import UIKit

public protocol ReuseIdentifier {
  static var reuseIdentifier: String { get }
}

public extension ReuseIdentifier {
  public static var reuseIdentifier: String {
    return String(describing: Self.self)
  }
}

extension UICollectionReusableView: ReuseIdentifier {

}

extension UITableViewCell: ReuseIdentifier {

}
