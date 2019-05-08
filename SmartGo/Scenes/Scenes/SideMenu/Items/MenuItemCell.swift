//
//  MenuItemCell.swift
//  SmartGo
//
//  Created by Nguyễn Phạm Thiên Bảo on 5/6/19.
//  Copyright © 2019 Luan Nguyen. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell, ReuseNib {
  
  @IBOutlet weak var itemImage: UIImageView!
  @IBOutlet weak var itemTitle: UILabel!
  @IBOutlet weak var itemIconView: UIView!
  @IBOutlet weak var itemTitleView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  private func setupUIItemIconView(background: UIColor) {
    itemIconView.corner(value: 5)
    itemIconView.backgroundColor = background
    itemIconView.alpha = 0.6
  }
  
  private func setupUIItemTitleView() {
    itemTitleView.addBorder(edge: .bottom, borderColor: .lightGray, thickness: 0.5, ratio: 1)
  }
  
  public func updateData(image: UIImage, title: String, colorIcon: UIColor) {
    itemImage.image = image
    itemImage.tintColor = UIColor.white
    itemTitle.text = title
    setupUIItemIconView(background: colorIcon)
    setupUIItemTitleView()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
