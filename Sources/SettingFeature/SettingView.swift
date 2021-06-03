//
//  SettingView.swift
//  Seed
//
//  Created by lcr on 2021/06/01.
//  
//

import ComposableArchitecture
import SwiftUI

public struct SettingState: Equatable {
    public init() {}
}

public enum SettingAction: Equatable {
    case changeIcon
}

public struct SettingEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.mainQueue = mainQueue
    }
}

public let settingReducer = Reducer<SettingState, SettingAction, SettingEnvironment> { _, action, _ in
    switch action {
    case .changeIcon:
        return .none
    }
}

public struct SettingView: View {
    let store: Store<SettingState, SettingAction>

    public init(store: Store<SettingState, SettingAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                List {
                    Section {
                        Text("Icon")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Setting")
        }
    }
}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView.preview
//    }
//}
