//
//  HomeScreen.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @State private var homeScreenVM = HomeScreenVM(apiClient: APIClient())
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                //MARK: - Header
                HeaderView()
                    .background(.ultraThinMaterial)
                
                //MARK: - Filter
                FilterBarView(homeScreenVM: homeScreenVM)
                    .padding(.bottom)
                    .background(.ultraThinMaterial)
                
                //MARK: - Race List
                List(homeScreenVM.filteredRaceList, id: \.raceId) { race in
                    LabeledContentCell(race: race)
                }
                .task {
                    await homeScreenVM.fetchNextRaces()
                }
                
            } //: VStack
            .navigationTitle("NEXT TO GO RACING")
            .navigationBarTitleDisplayMode(.inline)
        } //: NavigationStack
    }
}

#Preview {
    HomeScreen()
}
