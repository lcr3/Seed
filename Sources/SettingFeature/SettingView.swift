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
