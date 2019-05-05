//
//  TextView.swift
//  ServicePlatform
//
//

public extension UITextView {

  /// Determining position of cursor in textview
  ///
  /// - Returns: position
  public func cursorPosition() -> CGPoint {
    if let start = selectedTextRange?.start {
      return caretRect(for: start).origin
    }
    return .zero
  }

  public func autoHeight() -> CGFloat {
    let fixedWidth: CGFloat = frame.size.width
    let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    return newSize.height
  }

  public func lines() -> Int {
    if let lineHeight = font?.lineHeight {
      return Int((contentSize.height - textContainerInset.top - textContainerInset.bottom)/lineHeight)
    }
    return 0
  }

  public func setLineHeight(_ lineHeight: CGFloat) {
    var attrString: NSMutableAttributedString
    if let attributedText = self.attributedText {
      attrString = NSMutableAttributedString(attributedString: attributedText)
    } else {
      attrString = NSMutableAttributedString(string: text)
    }
    let style = NSMutableParagraphStyle()
    //    style.lineSpacing = lineHeight
    style.lineHeightMultiple = lineHeight
    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight
    attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: text.count))

    self.attributedText = attrString
  }
}
