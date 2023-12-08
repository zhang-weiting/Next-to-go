//
//  LabeledContentCell.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/7/23.
//

import SwiftUI

struct LabeledContentCell: View {
    
    var race: Race
    @Bindable var homeScreenVM: HomeScreenVM
    
    var body: some View {
        LabeledContent {
            Text(homeScreenVM.formatted(race.remainingSeconds))
        } label: {
            HStack() {
                Image("\(race.category.description)Racing")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 70)
                Text("\(race.raceNumber)")
                Text(race.meetingName)
            }
        }
    }
}

#Preview {
    LabeledContentCell(race: Race(raceId: "123", meetingName: "meeting name", raceNumber: 1, remainingSeconds: 132, category: .horse), homeScreenVM: HomeScreenVM(apiClient: APIClient()))
}
