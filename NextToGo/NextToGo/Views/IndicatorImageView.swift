//
//  IndicatorImageView.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import SwiftUI

struct IndicatorImageView: View {
    
    let race : RaceType
    var handler: (Bool) -> Void
    @State var isSelected = true
    
    var body: some View {
        VStack(spacing: 0) {
            Image(race.image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .onTapGesture {
                    isSelected.toggle()
                    handler(isSelected)
                }
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .frame(width: 80, height: 5)
                .foregroundStyle(isSelected ? Color.customOrangeLight : .clear)
                .animation(.default, value: isSelected)
            
        }
    }
}

#Preview {
    IndicatorImageView(race: .greyhound, handler: { _ in } )
}
