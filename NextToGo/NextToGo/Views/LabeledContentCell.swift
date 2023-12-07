//
//  LabeledContentCell.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/7/23.
//

import SwiftUI

struct LabeledContentCell: View {
    
    var race: Race
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeCountDown = ""
    @Bindable var homeScreenVM: HomeScreenVM
    
    var body: some View {
        LabeledContent {
            Text(timeCountDown)
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
        .onReceive(timer, perform: { _ in
            timeCountDown = homeScreenVM.countdown(race: race)
        })
        .onAppear {
            timeCountDown = homeScreenVM.countdown(race: race)
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

#Preview {
    LabeledContentCell(race: Race(raceId: "123", meetingName: "meeting name", raceNumber: 1, advertisedStart: 171299000, category: .horse), homeScreenVM: HomeScreenVM(apiClient: APIClient()))
}
