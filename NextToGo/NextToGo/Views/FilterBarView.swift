//
//  FilterBarView.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import SwiftUI

struct FilterBarView: View {
    
    @Bindable var homeScreenVM: HomeScreenVM
    
    var body: some View {
        HStack(spacing: 25) {
            Spacer()
            ForEach(Race.Category.allCases, id: \.self) { category in
                IndicatorImageView(category: category, handler: { selected in
                    homeScreenVM.updateFilter(category, selected: selected)
                })
            }
            Spacer()
        } //: HStack
    }
}

#Preview {
    FilterBarView(homeScreenVM: HomeScreenVM(apiClient: APIClient()))
}
