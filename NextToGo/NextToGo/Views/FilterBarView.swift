//
//  FilterBarView.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import SwiftUI

struct FilterBarView: View {
    
    @Binding var viewModel: HomeScreenVM
    
    var body: some View {
        HStack(spacing: 25) {
            Spacer()
            ForEach(RaceType.allCases, id: \.self) { race in
                IndicatorImageView(race: race, handler: { bool in
                    switch race {
                    case .greyhound:
                        viewModel.isGreyhoundSelected.toggle()
                    case .horse:
                        viewModel.isHorseSelected.toggle()
                    case .harness:
                        viewModel.isHarnessSelected.toggle()
                    }
                })
            }
            Spacer()
        }
    }
}

#Preview {
    @State var vm = HomeScreenVM()
    return FilterBarView(viewModel: $vm)
}
