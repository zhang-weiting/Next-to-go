//
//  HeaderView.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "laurel.leading")
                .font(.system(size: 80, weight: .black))
            Image(systemName: "flag.checkered.2.crossed")
                .font(.system(size: 80, weight: .semibold))
            Image(systemName: "laurel.trailing")
                .font(.system(size: 80, weight: .black))
            Spacer()
        } //: HStack
        .foregroundStyle(
            LinearGradient(
                colors: [
                    .customOrangeLight,
                    .customOrangeMedium],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .padding(.top, 8)
    }
}

#Preview {
    HeaderView()
}
