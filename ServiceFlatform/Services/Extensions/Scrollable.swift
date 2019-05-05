//
//  Scrollable.swift
//  ServicePlatform
//
//

import RxCocoa
import RxSwift

// MARK: - TableView
public extension UITableView {

  /// Adding a custom see more view that contains an activity indicator view
  ///
  /// - Parameter color: color of activity indicator, default is gray color
  public func seeMoreFooter(color: UIColor = .gray) {
    self.tableFooterView = self.initializeIndicator()
  }

  /// Determine whether the last cell is visible on Screen or not
  public func isLastCellVisible(reduce: CGFloat = 13) -> Bool {
    if let lastVisibleIdxPath = indexPathsForVisibleRows?.last {
      let lastSection = numberOfSections - 1
      let lastRow = numberOfRows(inSection: lastSection) - 1
      if lastSection == lastVisibleIdxPath.section && lastVisibleIdxPath.row == lastRow {
        if let cell = cellForRow(at: lastVisibleIdxPath) {
          cell.size.height -= reduce
          let rect = convert(cell.frame, to: superview)
          return frame.contains(rect)
        }
      }
    }
    return false
  }

  /// Getting indexpath of last cell
  public var lastIndexPath: IndexPath {
    let lastSection = numberOfSections - 1
    let lastRow = numberOfRows(inSection: lastSection) - 1
    return IndexPath(row: lastRow, section: lastSection)
  }
}

public extension UIScrollView {

  public var isAtTop: Bool {
    return contentOffset.y <= verticalOffsetForTop
  }

  public var isAtBottom: Bool {
    return contentOffset.y >= verticalOffsetForBottom
  }

  public var verticalOffsetForTop: CGFloat {
    let topInset = contentInset.top
    return -topInset
  }

  public var verticalOffsetForBottom: CGFloat {
    let scrollViewHeight = bounds.height
    let scrollContentSizeHeight = contentSize.height
    let bottomInset = contentInset.bottom
    let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
    return scrollViewBottomOffset
  }

  public func scrollToBottom(animated: Bool = true) {
    let ypos = verticalOffsetForBottom
    let xpos = contentOffset.x
    setContentOffset(CGPoint(x: xpos, y: ypos), animated: animated)
  }

  public func scrollToTop(animated: Bool = true) {
    setContentOffset(.zero, animated: animated)
  }
  
  func configRefreshControl(_ viewController: UIViewController) {
    let refresh = UIRefreshControl()
    if #available(iOS 10.0, *) {
      self.refreshControl = refresh
    } else {
      self.addSubview(refresh)
    }
  }
  
  public func endRefresh() {
    self.refreshControl?.endRefreshing()
  }
}

extension UIRefreshControl {
  
  public func driver() -> Driver<()>{
    return self.rx.controlEvent(.valueChanged).asDriver()
  }
}

public extension UITableViewCell {

  public func optimization() {
    /// Using masksToBounds on cell might leak memory and cause scrolling laggy
    /// These code will help to avoid this issue
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
}

public extension UICollectionViewCell {

  public func optimization() {
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
}

// MARK: - UICollectionView
public extension UICollectionView {
  
  public func scrollToIndexPathIfNotVisible(_ indexPath: IndexPath) {
    let section = indexPath.section
    if indexPath.row < self.numberOfItems(inSection: section) {
      self.scrollToItem(at: indexPath, at: [.bottom, .centeredHorizontally], animated: false)
    }
    self.layoutIfNeeded()
  }

  public func scrollToAndGetCell(atIndexPath indexPath: IndexPath) -> UICollectionViewCell! {
    scrollToIndexPathIfNotVisible(indexPath)
    return self.cellForItem(at: indexPath)
  }
}
