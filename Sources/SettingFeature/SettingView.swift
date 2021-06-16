//
//  SettingView.swift
//  Seed
//
//  Created by lcr on 2021/06/01.
//  
//

import Component
import ComposableArchitecture
import SwiftUI

public struct SettingState: Equatable {
    public static let defaultFontSizePoint = 0.0
    public var isUseSystemFontSize: Bool
    public var fontSizePoint: Double
    public let fontSizeMaxPoint: Double = 5.0

    public init() {
        isUseSystemFontSize = true
        fontSizePoint = 0.0
    }
}

public enum SettingAction: Equatable {
    case toggleIsUseSystemFontSize
    case sliderFontSizeChanged(Double)
}

public struct SettingEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.mainQueue = mainQueue
    }
}

public let settingReducer = Reducer<SettingState, SettingAction, SettingEnvironment> { state, action, _ in
    switch action {
    case .toggleIsUseSystemFontSize:
        state.isUseSystemFontSize.toggle()
        if state.isUseSystemFontSize {
            state.fontSizePoint = SettingState.defaultFontSizePoint
        }
        return .none
    case let .sliderFontSizeChanged(value):
        state.fontSizePoint = value
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
                    Section {
                        IconMenuView(
                            store: Store(
                                initialState: .init(),
                                reducer: iconMenuReducer,
                                environment: .init(
                                    mainQueue: .main.eraseToAnyScheduler(),
                                    client: .live
                                )
                            )
                        )
                    }
                    Section {
                        VStack {
                            HStack {
                                Text("Use system font size")
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity,
                                           alignment: .leading)
                                Spacer()
                                Toggle("", isOn:
                                        viewStore.binding(
                                            get: \.isUseSystemFontSize,
                                            send: SettingAction.toggleIsUseSystemFontSize
                                        )
                                )
                                .frame(maxWidth: 70)
                            }
                            HStack(spacing: 60) {
                                Text("Size")
                                    .disabled(viewStore.isUseSystemFontSize)
                                Slider(
                                    value: viewStore.binding(
                                        get: \.fontSizePoint,
                                        send: SettingAction.sliderFontSizeChanged
                                    ),
                                    in: 0...Double(viewStore.fontSizeMaxPoint),
                                    step: 1.0
                                ).disabled(viewStore.isUseSystemFontSize)
                            }
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
        SettingView(
            store: Store(
                initialState: SettingState(),
                reducer: settingReducer,
                environment: SettingEnvironment(
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
    }
}
