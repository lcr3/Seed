//
//  CreateDiaryView.swift
//  Seed
//
//  Created by lcr on 2021/05/09.
//
//

import Component
import ComposableArchitecture
import SwiftUI

public struct CreateDiaryView: View {
    public init(store: Store<CreateDairyState, CreateDairyAction>) {
        self.store = store
    }

    @Environment(\.presentationMode) @Binding var presentationMode
    let store: Store<CreateDairyState, CreateDairyAction>

    public var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Picker("", selection: viewStore.binding(
                    get: \.selectedSegment,
                    send: CreateDairyAction.tapSegment
                ).animation()) {
                    ForEach(viewStore.state.segments, id: \.self) {
                        Text($0.title)
                            .tag($0.title)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                List {
                    Section(header: Text("Title")) {
                        TextField(
                            "What happened today...",
                            text: viewStore.binding(
                                get: \.title,
                                send: CreateDairyAction.changeTitle
                            )
                        )
                            .multilineTextAlignment(.trailing)
                    }
                    if viewStore.state.selectedSegment.isMemo {
                        Section(header: Text("Contents")) {
                            TextEditor(
                                text: viewStore.binding(
                                    get: \.content,
                                    send: CreateDairyAction.changeContent
                                )
                            )
                        }
                    } else {
                        Section(header: Text("When")) {
                            TextEditor(
                                text: viewStore.binding(
                                    get: \.when,
                                    send: CreateDairyAction.changeWhen
                                )
                            )
                        }
                        Section(header: Text("Where")) {
                            TextEditor(
                                text: viewStore.binding(
                                    get: \.where_,
                                    send: CreateDairyAction.changeWhere
                                )
                            )
                        }
                        Section(header: Text("Who")) {
                            TextEditor(
                                text: viewStore.binding(
                                    get: \.who,
                                    send: CreateDairyAction.changeWho
                                )
                            )
                        }
                        Section(header: Text("Why")) {
                            TextEditor(
                                text: viewStore.binding(
                                    get: \.why,
                                    send: CreateDairyAction.changeWhy
                                )
                            )
                        }
                        Section(header: Text("How")) {
                            TextEditor(
                                text: viewStore.binding(
                                    get: \.how,
                                    send: CreateDairyAction.changeHow
                                )
                            )
                        }
                        Section(header: Text("Happened")) {
                            TextEditor(
                                text: viewStore.binding(
                                    get: \.happened,
                                    send: CreateDairyAction.changeHappened
                                )
                            )
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarItems(
                    trailing: Button("保存") {
                    presentationMode.dismiss()
                }
                ).onDisappear {
                    if viewStore.state.documentId.isEmpty {
                        viewStore.send(.create)
                    } else {
                        viewStore.send(.update)
                    }
                }
            }.background(Color.listGray)
        }
    }
}

 struct CreateDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDiaryView(
            store: .init(
                initialState: .init(),
                reducer: createDairyReducer,
                environment: .init(
                    client: .mock,
                    mainQueue: .main.eraseToAnyScheduler()
                )
            )
        )
//        CreateDiaryView.preview.environment(\.colorScheme, .dark)
    }
 }
