# Date Extensions for Swift

A handy Swift Date extension providing easy access to date components, safe initializers, day-based comparisons, localized month and weekday names, formatting helpers, and string keys for dictionary storage.

**Features**
- Access date components with simple properties:
    - year, month, day, hour, minute, second
- Localized month and weekday names, full and abbreviated:
    - monthNameFull / monthNameShort
    - weekdayFull / weekdayShort
- Safe date initializer from day/month/year, clamps invalid inputs to valid ranges.
- Day-based comparisons that ignore time components:
    - isWithinToday(date:)
    - isWithinSevenDays(date:)
    - isWithinThirtyDays(date:)
- Check if date is a weekday or weekend:
    - isWeekday, isWeekend
- String representations:
    - asString — a consistent "YYYY.MM.DD" format, padded for sorting and dictionary keys
    - init?(fromKey:) — parse a date from the string key
- Human-friendly formatting:
    - formattedDate — medium style date (e.g., “Aug 8, 2025”)
    - formattedTime — short style time (e.g., “2:05 PM”)
    - relativeDescription — relative date string (e.g., “3 days ago”, “in 2 weeks”)

All functions are calendar-aware and respect the user’s current locale and time zone.

## Installation

Swift Package Manager

Add this repository to your project:
1. In Xcode, go to File > Add Packages…
2. Paste the repo URL into the search field.
3. Add the package to your target.

Or add it directly in your Package.swift:

```swiftui
dependencies: [
    .package(url: "https://github.com/yourusername/DateExtensions.git", from: "1.0.0")
]
```


## Usage

```swift
import Foundation

let myDate = Date(day: 31, month: 2, year: 2025)  // Safely clamps to Feb 28, 2025
print(myDate.asString)                            // "2025.02.28"
print(myDate.monthNameFull)                       // "February" (localized)
print(myDate.weekdayShort)                        // "Fri" (localized)

let now = Date()
print(now.isWithinToday(date: myDate))           // true/false depending on today
print(now.isWithinSevenDays(date: myDate))       // true/false depending on date difference
print(now.relativeDescription)                    // e.g., "in 5 days"
```

## Why?

Working with Date and Calendar in Swift can be verbose and error-prone.
This extension keeps the power of Calendar but removes the boilerplate.
