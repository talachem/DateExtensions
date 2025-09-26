// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 15.0, *)
public extension Date {
    private var calendar: Calendar { Calendar.current }
    
    var year: Int { calendar.component(.year, from: self) }
    var month: Int { calendar.component(.month, from: self) }
    var day: Int { calendar.component(.day, from: self) }
    var hour: Int { calendar.component(.hour, from: self) }
    var minute: Int { calendar.component(.minute, from: self) }
    var second: Int { calendar.component(.second, from: self) }
    
    // MARK: Month and Weekday Names
    private static let monthFormatterFull: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"  // Full month name, e.g., "August"
        return formatter
    }()
    
    private static let weekdayFormatterFull: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // Full weekday name, e.g., "Friday"
        return formatter
    }()
    
    var monthNameFull: String {
        Self.monthFormatterFull.string(from: self)
    }
    
    var weekdayFull: String {
        Self.weekdayFormatterFull.string(from: self)
    }
    
    private static let monthFormatterShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"  // Full month name, e.g., "August"
        return formatter
    }()
    
    private static let weekdayFormatterShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"  // Full weekday name, e.g., "Friday"
        return formatter
    }()
    
    var monthNameShort: String {
        Self.monthFormatterShort.string(from: self)
    }
    
    var weekdayShort: String {
        Self.weekdayFormatterShort.string(from: self)
    }
    
    /// Returns this date truncated to start-of-day
    var startOfDay: Date {
        calendar.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
    
    func isSameDay(as date: Date) -> Bool {
        calendar.isDate(self, inSameDayAs: date)
    }
    
    /// Checks if the given date is in the same day as `self` (ignoring time)
    func isWithinOneDay(date: Date) -> Bool {
        let dayDiff = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay).day ?? .max
        return abs(dayDiff) <= 1
    }
    
    /// Checks if the given date is within 7 calendar days from `self`
    func isWithinSevenDays(date: Date) -> Bool {
        let dayDiff = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay).day ?? .max
        return abs(dayDiff) <= 7
    }
    
    /// Checks if the given date is within 30 calendar days from `self`
    func isWithinThirtyDays(date: Date) -> Bool {
        let dayDiff = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay).day ?? .max
        return abs(dayDiff) <= 30
    }
    
    func isWithinDays(days: Int, date: Date) -> Bool {
        let dayDiff = calendar.dateComponents([.day], from: self.startOfDay, to: date.startOfDay).day ?? .max
        return abs(dayDiff) <= days
    }
    
    // Init from day/month/year
    init(day: Int, month: Int, year: Int) {
        var components = DateComponents()
        
        // Clamp month to 1...12
        let safeMonth = month.clamped(to: 1...12)
        
        // Days in month lookup, accounting for leap years
        let daysInMonth: [Int: Int] = [
            1: 31, 2: year.isLeapYear ? 29 : 28, 3: 31,
            4: 30, 5: 31, 6: 30, 7: 31,
            8: 31, 9: 30, 10: 31, 11: 30, 12: 31
        ]
        
        // Clamp day to valid range for that month
        let safeDay = day.clamped(to: 1...(daysInMonth[safeMonth] ?? 1))
        
        components.day = safeDay
        components.month = safeMonth
        components.year = year
        
        self = Calendar.current.date(from: components)!
    }
    
    var isWeekday: Bool {
        !calendar.isDateInWeekend(self)
    }
    
    var isWeekend: Bool {
        calendar.isDateInWeekend(self)
    }
    
    /// Returns true if the date is before "now"
    var isInPast: Bool {
        self < Date()
    }
    
    /// Returns true if the date is after "now"
    var isInFuture: Bool {
        self > Date()
    }
    
    /// Returns true if the date is exactly "today"
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Returns true if the date is tomorrow
    var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(self)
    }

    /// Returns true if the date was yesterday
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    var isThisWeek: Bool {
        calendar.isDate(self, equalTo: .now, toGranularity: .weekOfYear)
    }
    
    var isLastWeek: Bool {
        guard let prevWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: .now) else { return false }
        return calendar.isDate(self, equalTo: prevWeek, toGranularity: .weekOfYear)
    }
    
    var isThisMonth: Bool {
        calendar.isDate(self, equalTo: .now, toGranularity: .month)
    }
    
    var isLastMonth: Bool {
        guard let prevMonth = calendar.date(byAdding: .month, value: -1, to: .now) else { return false }
        return calendar.isDate(self, equalTo: prevMonth, toGranularity: .month)
    }
    
    func isSameWeek(as date: Date) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }

    func isPreviousWeek(of date: Date) -> Bool {
        guard let prevWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: date) else { return false }
        return calendar.isDate(self, equalTo: prevWeek, toGranularity: .weekOfYear)
    }

    func isSameMonth(as date: Date) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: .month)
    }

    func isPreviousMonth(of date: Date) -> Bool {
        guard let prevMonth = calendar.date(byAdding: .month, value: -1, to: date) else { return false }
        return calendar.isDate(self, equalTo: prevMonth, toGranularity: .month)
    }
    
    /// Checks if the date is the first day of its week
    var isFirstDayOfWeek: Bool {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: self) else { return false }
        return calendar.isDate(self, inSameDayAs: weekInterval.start)
    }

    /// Checks if the date is the last day of its week
    var isLastDayOfWeek: Bool {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: self) else { return false }
        // Subtract 1 second from the end to get the last day
        let lastDay = calendar.date(byAdding: .second, value: -1, to: weekInterval.end) ?? weekInterval.end
        return calendar.isDate(self, inSameDayAs: lastDay)
    }

    /// Checks if the date is the first day of its month
    var isFirstDayOfMonth: Bool {
        guard let monthInterval = calendar.dateInterval(of: .month, for: self) else { return false }
        return calendar.isDate(self, inSameDayAs: monthInterval.start)
    }

    /// Checks if the date is the last day of its month
    var isLastDayOfMonth: Bool {
        guard let monthInterval = calendar.dateInterval(of: .month, for: self) else { return false }
        let lastDay = calendar.date(byAdding: .second, value: -1, to: monthInterval.end) ?? monthInterval.end
        return calendar.isDate(self, inSameDayAs: lastDay)
    }
    
    var asString: String {
        let y = year
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        return "\(y).\(m).\(d)"
    }
    
    init?(fromKey key: String) {
        let parts = key.split(separator: ".").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        self.init(day: parts[2], month: parts[1], year: parts[0])
    }
    
    // MARK: - Formatters
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium   // e.g., "Aug 8, 2025"
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short    // e.g., "2:05 PM"
        return formatter
    }()
    
    @MainActor
    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full    // "3 days ago", "in 2 weeks"
        return formatter
    }()
    
    /// Example: "Aug 8, 2025"
    var formattedDate: String {
        Self.dateFormatter.string(from: self)
    }
    
    /// Example: "2:05 PM"
    var formattedTime: String {
        Self.timeFormatter.string(from: self)
    }
    
    /// Example: "3 days ago" or "in 2 weeks"
    @available(iOS 15.0, macOS 10.15, *)
    var relativeDescription: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: .now)
    }
    
    static func ago(days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> Date {
        let calendar = Calendar.current
        let base = calendar.startOfDay(for: Date())
        
        var components = DateComponents()
        components.day = -(days + weeks * 7)
        components.month = -months
        components.year = -years
        
        let result = calendar.date(byAdding: components, to: base)!
        return calendar.startOfDay(for: result)
    }
    
    static func `in`(days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> Date {
        let calendar = Calendar.current
        let base = calendar.startOfDay(for: Date())
        
        var components = DateComponents()
        components.day = days + weeks * 7
        components.month = months
        components.year = years
        
        let result = calendar.date(byAdding: components, to: base)!
        return calendar.startOfDay(for: result)
    }}

fileprivate extension Int {
    var isLeapYear: Bool {
        if self.isMultiple(of: 400) { return true }
        if self.isMultiple(of: 100) { return false }
        if self.isMultiple(of: 4) { return true }
        return false
    }
}

fileprivate extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
