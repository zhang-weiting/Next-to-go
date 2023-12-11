//
//  HomeScreen.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @Environment(\.scenePhase) var scenePhase
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
                List(homeScreenVM.renderRaceList(), id: \.raceId) { race in
                    LabeledContentCell(race: race, homeScreenVM: homeScreenVM)
                }
                .animation(.default, value: homeScreenVM.renderRaceList())
                
            } //: VStack
            .navigationTitle("NEXT TO GO RACING")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(homeScreenVM.timer, perform: { _ in
                homeScreenVM.countdown()
            })
            .onChange(of: homeScreenVM.errorMessage, { _, newValue in
                homeScreenVM.showAlert = !newValue.isEmpty
            })
            .alert(isPresented: $homeScreenVM.showAlert, content: {
                Alert(title: Text(homeScreenVM.errorMessage))
            })
            .onChange(of: homeScreenVM.activeRaceList.count) { oldValue, newValue in
                if newValue < oldValue {
                    homeScreenVM.autoRefresh()
                }
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    homeScreenVM.autoRefresh()
                    homeScreenVM.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                } else {
                    homeScreenVM.timer.upstream.connect().cancel()
                }
            }
        } //: NavigationStack
    }
}

#Preview {
    HomeScreen()
}
