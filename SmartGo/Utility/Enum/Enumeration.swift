import UIKit

public enum FantasyType {
  case email, common
}

public enum MediaAuthorization {
  case authorized
  case denied
  case unknown
}

public enum Storyboard: String {
  case home = "Home"
  case menu = "SideMenu"
  case signin = "SignIn"
  case register = "Register"
}

public enum StateButton {
  case hide
  case show
}

public enum UserProfileTextField: String {
  case email = "Email"
  case password = "Password"
  case confirm = "Confirm password"
}

public enum MenuItems: String, CaseIterable {
  case notification = "Notifications"
  case sound = "Sounds"
  case mode = "Mode"
  case contact = "Contact"
  case setting = "Setting"
  case signout = "Sign Out"
  
  var color: UIColor {
    switch self {
    case .notification:
      return UIColor.red
    case .sound:
      return UIColor.blue
    case .mode:
      return UIColor.purple
    case .contact:
      return UIColor.brown
    case .setting:
      return UIColor.gray
    default:
      return UIColor.orange
    }
  }
}

public enum MenuItemIcons: String, CaseIterable {
  case notification = "ic-notification"
  case sound = "ic-sound"
  case mode = "ic-mode"
  case contact = "ic-contact"
  case setting = "ic-setting"
  case signout = "ic-logout"
}

public enum NavigationTitle: String {
  case signin = "Sign In"
}

public enum UserCollection: String {
  case firstName = "firstName"
  case lastName = "lastName"
  case fullName = "fullName"
  case email = "email"
  case id = "id"
  case phone = "phone"
  case address = "address"
  case birthday = "birthday"
}

