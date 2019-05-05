//
//  Validation.swift
//  ServicePlatform
//

//

public struct Validation {

  public static func usernameValidation(username: String) -> Bool {
    //  - Lowercasecharacters{a-z}
    //  - Uppercasecharacters{A-Z}
    //  - Numbers{0-9}
    //  - Dash{-}
    //  - Underscore{_}
    let userNameRegEx = "\\A[a-zA-Z0-9_-]{3,15}\\z"
    let userNameTest = NSPredicate(format:"SELF MATCHES %@", userNameRegEx)
    return userNameTest.evaluate(with: username)
  }
  
  public static func numberValidation(number: String) -> Bool {
    //  - Numbers{0-9}
    let numberRegEx = "\\A[0-9]{1,20}\\z"
    let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
    return numberTest.evaluate(with: number)
  }

  public static func emailValidation(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }

  // using for validate first and last name
  public static func nameValidation(name: String) -> Bool {
    //  - Lowercase characters {a-z}
    //  - Uppercase characters {A-Z}
    //  - Dash {-}
    let userNameRegEx = "\\A[a-zA-Z-]{1,}\\z"
    let userNameTest = NSPredicate(format:"SELF MATCHES %@", userNameRegEx)
    return userNameTest.evaluate(with: name)
  }

  public static func socialNameValidation(socialName: String) -> Bool {
    //  - Lowercase characters {a-z}
    //  - Uppercase characters {A-Z} - Digits {0-9}
    //  - Period {.}
    let userNameRegEx = "\\A[a-zA-Z0-9.]{1,}\\z"
    let userNameTest = NSPredicate(format:"SELF MATCHES %@", userNameRegEx)
    return userNameTest.evaluate(with: socialName)
  }
  
  public static func passwordValidation(password: String) -> Bool {
    // Password should be at least 8 characters long
    let lengthResult = password.count >= 8
    
    // Password should contain at least one uppercase latter
    let capsRegEx  = ".*[A-Z]+.*"
    let capsTest = NSPredicate(format:"SELF MATCHES %@", capsRegEx)
    let capsResult = capsTest.evaluate(with: password)
    
    // at least one lowercase latter
    let lowerRegEx  = ".*[a-z]+.*"
    let lowerTest = NSPredicate(format:"SELF MATCHES %@", lowerRegEx)
    let lowerResult = lowerTest.evaluate(with: password)
    
    // at least one numnber
    let numberRegEx  = ".*[0-9]+.*"
    let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
    let numberResult = numberTest.evaluate(with: password)
    
    // and at least one special character
    let specialChars  = CharacterSet(charactersIn: "^$*.[]{}()?-\"!@#%&/\\,><\':;|_~`")
    let specialResult = password.rangeOfCharacter(from: specialChars).notNil
    
    return lengthResult && capsResult && lowerResult && numberResult && specialResult
  }
  
  typealias T = CreditCardType
  public static func creditCardValidation(type: String, creditCardNumber: String) -> Bool {
    var typeRegEx = ""
    switch type {
    case T.Visa: // Example: 4111111111111111
      typeRegEx = "^4[0-9]{12}(?:[0-9]{3})?$"
    case T.MasterCard:  // Example: 5538383883833838
      typeRegEx = "^5[1-5][0-9]{14}$"
    case T.AmericanExpress: // Example: 347000000000000
      typeRegEx = "^3[47][0-9]{13}$"
    case T.DinersClub:  // Example: 30099999999999
      typeRegEx = "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
    case T.Discover:  // Example: 6550000000000000
      typeRegEx = "^6(?:011|5[0-9]{2})[0-9]{12}$"
    case T.JCB: // Example: 180000000000000
      typeRegEx = "^(?:2131|1800|35\\d{3})\\d{11}$"
    default:
      break
    }
    let typeTest = NSPredicate(format:"SELF MATCHES %@", typeRegEx)
    return typeTest.evaluate(with: creditCardNumber)
  }
}
