//
//  CountDownFormat.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/7/23.
//

import Foundation

struct CountDownFormat: FormatStyle {
    func format(_ value: TimeInterval) -> String {
        let time = value - Date().timeIntervalSince1970
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: time) ?? ""
    }
}

extension FormatStyle where Self == CountDownFormat {
    static var countdown: CountDownFormat {
        CountDownFormat()
    }
}
