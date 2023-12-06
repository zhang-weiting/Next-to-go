//
//  HomeScreen.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @State var homeScreenVM = HomeScreenVM()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                //MARK: - Header
                HeaderView()
                    .background(.ultraThinMaterial)
                
                //MARK: - Filter
                FilterBarView(viewModel: $homeScreenVM)
                    .background(.ultraThinMaterial)
                
                //MARK: - Race List
                List(homeScreenVM.filteredRaceList) { race in
                    LabeledContent {
                        Text(race.countdownDisplay)
                    } label: {
                        HStack() {
                            Image(race.raceType.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 70)
                            Text(race.raceNumber)
                            Text(race.meetingName)
                        }
                    }
                }
                .task(id: homeScreenVM.isFetching) {
                    if homeScreenVM.isFetching {
                        await homeScreenVM.fetchNextRacesByCount(10)
                    }
                }
                .animation(.default, value: homeScreenVM.filteredRaceList.count)
                
            } //: VStack
            .navigationTitle("NEXT TO GO RACING")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                homeScreenVM.isFetching = true
            })
            .onReceive(homeScreenVM.timer, perform: { _ in
                
            })
        } //: NavigationStack
    }
}

#Preview {
    HomeScreen()
}
