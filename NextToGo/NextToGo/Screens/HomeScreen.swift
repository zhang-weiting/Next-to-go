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
                List(homeScreenVM.renderedList(), id: \.raceId) { race in
                    LabeledContentCell(race: race, homeScreenVM: homeScreenVM)
                }
                .task {
                    await homeScreenVM.fetchNextRaces()
                }
                
            } //: VStack
            .navigationTitle("NEXT TO GO RACING")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(homeScreenVM.timer, perform: { _ in
                homeScreenVM.countdown()
            })
            .onAppear {
                homeScreenVM.countdown()
            }
            .onChange(of: homeScreenVM.errorMessage, { _, newValue in
                if !newValue.isEmpty {
                    homeScreenVM.showAlert = true
                }
            })
            .alert(isPresented: $homeScreenVM.showAlert, content: {
                Alert(title: Text(homeScreenVM.errorMessage))
            })
        } //: NavigationStack
    }
}

#Preview {
    HomeScreen()
}
