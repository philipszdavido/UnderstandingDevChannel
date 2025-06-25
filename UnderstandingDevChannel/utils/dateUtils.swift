//
//  dateUtils.swift
//  UnderstandingDevChannel
//
//  Created by Chidume Nnamdi on 11/06/2025.
//

import Foundation

import Foundation

func formattedRelativeDate(from isoDate: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime]

    guard let date = isoFormatter.date(from: isoDate) else {
        return "Invalid date"
    }

    let now = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date, to: now)

    if let year = components.year, year >= 1 {
        // Over a year ago → full date
        return formattedFullDate(from: date)
    } else if let month = components.month, month >= 1 {
        return "\(month) month\(month > 1 ? "s" : "") ago"
    } else if let day = components.day, day >= 1 {
        return "\(day) day\(day > 1 ? "s" : "") ago"
    } else {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: now)
    }
}

private func formattedFullDate(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
