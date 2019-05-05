//
//  DateFormat.swift
//  ServicePlatform
//
//

import Foundation

public typealias DateFormatType = (DateFormat, String)

public enum DateFormat: String {
  case date = "MM/dd/yyyy"
  case year = "yyyy"
  case monthYear = "MM/yyyy"
  case dateInYear = "M/d/yyyy"
  case dateInMonth = "MMM d, h:mm a"
  case weekday = "EEEE, h:mm a"
  case time = "h:mm a"
  case standard = "yyyy-MM-dd HH:mm"
  case sortDate = "yyyy-MM-dd"
  case dateOnly = "MMMM d"
  case shortMonthDayOnly = "MMM d"
  case weekdayInMonth = "EEE, MMM d"
  case timeAndDate = "h:mm a, MMM d, yyyy"

  public var format: String {
    return rawValue
  }

  public static func dates(date: Date) -> [DateFormatType] {
    return [(.dateInYear, date.toDateInYearString()), (.dateInMonth, date.monthFormat()), (.weekday, date.weekdayFormat()), (.time, date.toTimeString())]
  }
}

public enum Terms: String {
  case yesterday = "Yesterday"
  case justNow = "Just now"
  case tomorrow = "Tomorrow"
  case today = "Today"
  public var desc: String {
    return rawValue
  }
}
