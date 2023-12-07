//
//  CountDownFormat.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/7/23.
//

import Foundation

//TODO: TO be cleaned up (this was the first approach since not too sure about what seconds represents in advertised_start
struct CountDownFormat: FormatStyle {
    func format(_ value: TimeInterval) -> String {
        let now = Date()
        let time = value - now.timeIntervalSince1970

        let date = Date(timeIntervalSince1970: time)
        let hour = Calendar.current.component(.hour, from: date)
        let minutes = Calendar.current.component(.minute, from: date)
        let seconds = Calendar.current.component(.second, from: date)

        return "\(hour)h \(minutes)m \(seconds)s"
    }
}

extension FormatStyle where Self == CountDownFormat {
    static var countdown: CountDownFormat {
        CountDownFormat()
    }
}
