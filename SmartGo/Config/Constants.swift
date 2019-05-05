//
//  Constants.swift
//  Timo
//
//  Copyright © 2018 Timo. All rights reserved.
//

// MARK: - Global constant variables
/*
 Seperating structs but not encapsulated in a big Constant struct to avoid too long call to a constant.
 Using sub structs as much as possible, this approach will make Constant struct organization better.
 In addition, this optimises compiling performance so much as well.
 */
import Foundation
import UIKit

public typealias CustomFields = [(String, String)]
public typealias InputDataContact = (name: String, value: [Any], type: InputtingType, values: [String]?)
typealias InputData = (name: String, value: String, type: InputtingType, values: [Any]?)

public enum InputtingType {
  case normal, dropdown, date, customField, country
}

struct Constant {

  // MARK: - Data Versions
  struct Version {

    static let User_Profile_Schema_Version: NSNumber = 1
  }

  // MARK: - Types constants
  struct Types {
    
    static let PersonalDetails = "Personal Details"
    static let ProfessionalDetails = "Professional Details"
    static let Address = "Address"
    static let ContactDetails = "Contact Details"
    static let CreditCard = "Credit Card"
    static let License = "License"
    static let Passport = "Passport"
    static let AutoInsurance = "Auto Insurance"
    static let HealthInsurance = "Health Insurance"
    static let Others = "Others"
    
    static let Addresses = "Addresses"
    static let CreditCards = "Credit Cards"
    static let Licenses = "Licenses"
    static let Passports = "Passports"
    static let AutoInsurances = "Auto Insurances"
    static let HealthInsurances = "Health Insurances"
  }
  
  // MARK: - Number constants
  struct Number {

  }

  // MARK: - String constants
  struct CString {
    
    static let AppName = "Timo"
    
    static let Email = "Email"
    static let Password = "Password"
    static let Confirmed = "Confirmed"
    static let UserId = "UserId"
    static let Name = "Name"
    static let GroupUserId = "GroupUserId"
    
    static let invalidEmail = "🔺 Please enter valid email!"
    
    static let NoImage = "NoImage"
    static let Blank = "Blank"
    static let IdRequestDefault = "111"
    static let EnterCategoryTitle = "Enter Category Title"
    static let EnterTitle = "Enter Title"
    
    // error message
    static let SharingRequestChanged = "This sharing request has made some changes, please reload it"
    static let SharingRequestDeleted = "This sharing request is no longer available"
    
    // group bundle id
    static let AppGroupName = "group.com.timox"
    
    /// Share
    static let request = "Request"
    static let share = "Share"
    static let oneTime = "One-time"
    static let sharingForWeek = "Sharing for a Week"
    static let sharingForYear = "Sharing for a Year"
    
    // prefix
    static let shared = "You shared"
    static let haveBeenShared = "You have been shared"
    static let haveRequested = "You have requested"
    static let haveBeenRequested = "You have been requested to share"
    
    /// Button title
    static let cancel = "Cancel"
    static let canceled = "Canceled"
    static let close = "Close"
    static let accept = "Accept"
    static let accepted = "Accepted"
    static let change = "Change"
    static let update = "Update"
    static let decline = "Decline"
    static let declined = "Declined"
    static let sendTo = "Send to"
    static let failed = "Failed"
    static let replaced = "Replaced"
    
    /// Error
    static let errorMessage = "Something went wrong!"
  }
  
  // MARK: - Array constants
  struct CArray {
    static let settings = [["QR Code"], ["Block Users"], ["Send Feedback"], ["About", "Terms & Conditions", "Privacy Policy", "Attributions"], ["Sign Out"]]
  }
  
  // MARK: - Dictionary constants
  struct CDictionary {
    
    static let CustomFieldBlank = ["CustomField": "CustomField"]
    static let CustomPhotoBlank = ["Photo": "Photo"]
  }

  // MARK: - Link
  struct Link {
    
    static let facebook = "https://facebook.com"
    static let twitter = "https://twitter.com"
    static let timo = "https://thanhcong83dn.github.io/"
    static let formApi = "https://thanhcong83dn.github.io/api/common/"
  }

  // MARK: - Notification
  struct NotificationName {
    static let addNewActivity = "kAddNewActivity"
    static let updateRequest = "kUpdateRequest"
  }
}

// MARK: - Global defining
// typealias Action = () -> Void
