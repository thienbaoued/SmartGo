//
//  TripTableViewCell.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/17/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell, ReuseNib {

  @IBOutlet weak var tripCellView: UIView!
  @IBOutlet weak var titleTrip: UILabel!
  
  var title: String? {
    didSet {
      guard let title = title else { return }
      self.titleTrip.text = title
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    setupUI()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
  func setupUI() {
    tripCellView.roundBorder(radius: 15)
    tripCellView.makeShadow(opacity: 0.5, radius: 5, height: 1, color: .darkGray, bottom: false, all: true)
  }
    
}
