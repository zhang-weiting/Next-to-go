//
//  CountDownFormat.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/7/23.
//

import Foundation

struct CountDownFormat: FormatStyle {
    
    ///an alternative way to display the countdown
    func format(_ value: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: value) ?? ""
    }
}

extension FormatStyle where Self == CountDownFormat {
    static var countdown: CountDownFormat {
        CountDownFormat()
    }
}
