//
//  SettingView.swift
//  Seed
//
//  Created by lcr on 2021/06/01.
//  
//

import ComposableArchitecture
import SwiftUI

struct SettingState: Equatable {
}

enum SettingAction: Equatable {
    case changeIcon
}

struct SettingEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let settingReducer = Reducer<SettingState, SettingAction, SettingEnvironment> { _, action, _ in
    switch action {
    case .changeIcon:
        return .none
    }
}

struct SettingView: View {
    let store: Store<SettingState, SettingAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Section {
                    HStack {
                        Text("Theme")
                        Spacer()
                        Text("Automatic")
                            .foregroundColor(.systemGray)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.systemGray)
                    }
                }
                .onTapGesture {
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView.preview
    }
}
