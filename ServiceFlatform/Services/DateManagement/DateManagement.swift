//
//  DateManagement.swift
//  ServicePlatform
//
//

import SwiftDate

public extension String {

  private func date(format: String) throws -> Date {
    if let dateInRegion = DateInRegion(self, format: format, region: .local) {
      return dateInRegion.date
    }
    return Date.today
  }
  public func toTime() -> Date {
    if let date = try? self.date(format: DateFormat.time.format) {
      return date
    }
    return Date.today
  }

  public func toDate() -> Date {
    if let date = try? self.date(format: DateFormat.standard.format) {
      return date
    }
    return Date.today
  }

  public func toDateOnly() -> String {
    if let date = try? self.date(format: DateFormat.dateOnly.format).toDateOnly() {
      return date
    }
    return self
  }

  public func toUTC() -> String {
    if let dateInRegion = DateInRegion(self, format: DateFormat.standard.format, region: .local) {
      return dateInRegion.convertTo(region: .UTC).toString(.custom(DateFormat.standard.format))
    }
    return self
  }

  public func toDateFromUTC(format: String = DateFormat.standard.format) -> Date {
    if let date = DateInRegion(self, format: format, region: .UTC) {
      return date.convertTo(region: .local).date
    }
    return Date.today
  }

  public func toDateString(format: String = DateFormat.standard.format) -> String {
    if let date = try? self.date(format: format).toStandardDateString() {
      return date
    }
    return self
  }

  public func diff() -> Int? {
    let today = Date.today
    let date = self.toDateFromUTC()
    return (today - date).in(.minute)
  }

  public func combineTime(end: String) -> String {
    let date = self.toDateFromUTC()
    let endStr = end.isEmpty ? "": " - " + end.toDateFromUTC().toTimeString()
    let time = date.toTimeString() + endStr
    return date.toDateOnly() + " " + time
  }

  public func comparasion(_ f: (Date, Date) -> Bool, target: String) -> Bool {
    return f(self.toDateFromUTC(), target.toDateFromUTC())
  }

  public func isTomorrow(end: String) -> String {
    let verifiedDate = end.toDate()
    let current = self.toDate()
    if !current.isSameDay(from: verifiedDate) {
      return end
    }
    if verifiedDate < self.toDate() {
      return (verifiedDate + 1.days).toDateString()
    }
    return end
  }

  public var isExpired: Bool {
    if self.isEmpty {
      return false
    }
    return self.toDateFromUTC().isBeforeDate(Date.today, granularity: .day)
  }
}

// MARK: - Date
public extension Date {

  public func roundUp() -> Date {
    var date = DateInRegion(self)
    if let minute = date.dateComponents.minute, minute > 0 {
      // swiftlint:disable shorthand_operator
      date = date + (60 - minute).minutes
    }
    return date.date
  }

  private func dateInRegion() -> DateInRegion {
    return DateInRegion(self, region: .local)
  }

  private func dateInRegion(format: String) -> DateInRegion {
    return DateInRegion(self, region: .local)
  }

  public func format(format: String) -> String {
    return dateInRegion().toString(.custom(format))
  }

  public func toTimeString() -> String {
    return self.format(format: DateFormat.time.format)
  }

  public func toDateString() -> String {
    return self.format(format: DateFormat.date.format)
  }
  
  public func toStandardDateString() -> String {
    return self.format(format: DateFormat.standard.format)
  }

  public func toDateInYearString() -> String {
    return self.format(format: DateFormat.dateInYear.format)
  }

  public func toShortDateString() -> String {
    return self.format(format: DateFormat.sortDate.format)
  }

  public func toTimeStringExt() -> String {
    return self.format(format: DateFormat.time.format).lowercased().replacingOccurrences(of: " ", with: "")
  }

  public func toDateOnly() -> String {
    return self.format(format: DateFormat.dateOnly.format)
  }

  public func weekdayMonthFormat() -> String {
    return self.format(format: DateFormat.weekdayInMonth.format)
  }

  public func shortMonthDayFormat() -> String {
    return self.format(format: DateFormat.shortMonthDayOnly.format)
  }

  public func monthFormat() -> String {
    return self.format(format: DateFormat.dateInMonth.format)
  }

  public func weekdayFormat() -> String {
    return self.format(format: DateFormat.weekday.format)
  }
  
  public func timeAndDateFormat() -> String {
    return self.format(format: DateFormat.timeAndDate.format)
  }

  public static var today: Date {
    return DateInRegion().date
  }

  public func dateUTC() -> String {
    let dateInRegion = DateInRegion(self, region: .local)
    return dateInRegion.convertTo(region: .UTC).toString(.custom(DateFormat.sortDate.format))
  }

  public var tomorrow: Date {
    return Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
  }

  /// Check the interval of self and inputting date is less than a specific detail second(10) or not
  public func lessThanDelta(_ delta: Int, date: Date) -> Bool {
    guard let interval = (self - date).in(.second) else { return false }
    return interval < delta
  }

  // Return short date format
  // Ex: 6:10am, Yesterday, Monday, June 1
  public func toShortDateFormat() -> String {
    if self.isToday {     return self.toTimeStringExt() }
    if self.isYesterday { return Terms.yesterday.desc }
    
    let today = Date.today
    let check = self.weekday >= firstDayOfWeek && self.weekday <= lastDayOfWeek && today.weekday >= firstDayOfWeek && today.weekday <= lastDayOfWeek
    if check { return weekdayName(.default) }
    return shortMonthDayFormat()
  }

  /// Returns true if they're same minute
  public func isSameMinute(from date: Date?) -> Bool {
    if let date = date {
      return Calendar.current.compare(date, to: self, toGranularity: .minute) == .orderedSame
    }
    return false
  }

  public func isSameDay(from date: Date?) -> Bool {
    if let date = date {
      return Calendar.current.compare(date, to: self, toGranularity: .day) == .orderedSame
    }
    return false
  }

  // // Ex: Today, Yesterday, Monday, June 1
  public func toDateWithSortFormat() -> String {
    if isToday {     return Terms.today.desc }
    if isYesterday { return Terms.yesterday.desc }
    
    let today = Date.today.weekday
    let check = self.weekday >= firstDayOfWeek && self.weekday <= lastDayOfWeek && today >= firstDayOfWeek && today <= lastDayOfWeek
    let result = self.toDateOnly()
    if check { return weekdayName(.default)  }
    return result
  }
}
