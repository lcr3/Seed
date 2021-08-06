//
//  DiaryDetailView.swift
//
//
//  Created by lcr on 2021/06/18.
//
//

import ComposableArchitecture
import SwiftUI
import FirebaseApiClient

public struct DiaryDetailView: View {
    public init(store: Store<DiaryDetailState, DiaryDetailAction>) {
        self.store = store
    }

    @Environment(\.presentationMode) @Binding var presentationMode
    public let store: Store<DiaryDetailState, DiaryDetailAction>
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                HStack {
                    Text("Title")
                    TextField(
                        "",
                        text: viewStore.binding(
                            get: \.editedTitle,
                            send: DiaryDetailAction.editTitle
                        )
                    )
                    .multilineTextAlignment(.trailing)
                }
                if viewStore.state.diary.contentType().isMemo {
                    Section(header: Text("Contents")) {
                        TextEditor(
                            text: viewStore.binding(
                                get: \.editedContent,
                                send: DiaryDetailAction.editContent
                            )
                        )
                    }
                } else {
                    Section(header: Text("When")) {
                        TextEditor(
                            text: viewStore.binding(
                                get: \.editedWhen,
                                send: DiaryDetailAction.editWhen
                            )
                        )
                    }
                    Section(header: Text("Where")) {
                        TextEditor(
                            text: viewStore.binding(
                                get: \.editedWhere,
                                send: DiaryDetailAction.editWhere
                            )
                        )
                    }
                    Section(header: Text("Who")) {
                        TextEditor(
                            text: viewStore.binding(
                                get: \.editedWho,
                                send: DiaryDetailAction.editWho
                            )
                        )
                    }
                    Section(header: Text("Why")) {
                        TextEditor(
                            text: viewStore.binding(
                                get: \.editedWhy,
                                send: DiaryDetailAction.editWhy
                            )
                        )
                    }
                    Section(header: Text("How")) {
                        TextEditor(
                            text: viewStore.binding(
                                get: \.editedHow,
                                send: DiaryDetailAction.editHow
                            )
                        )
                    }
                    Section(header: Text("Happened")) {
                        TextEditor(
                            text: viewStore.binding(
                                get: \.editedHappened,
                                send: DiaryDetailAction.editHappened
                            )
                        )
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onDisappear {
                viewStore.send(DiaryDetailAction.save)
            }
        }
    }
}

 struct DiaryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryDetailView(
            store: .init(
                initialState: .init(
                    diary: .init()
                ),
                reducer: diaryDetailReducer,
                environment: .init(
                    client: .mock,
                    mainQueue: .main.eraseToAnyScheduler()
                )
            )
        )
        DiaryDetailView(
            store: .init(
                initialState: .init(
                    diary: .init()
                ),
                reducer: diaryDetailReducer,
                environment: .init(
                    client: .mock,
                    mainQueue: .main.eraseToAnyScheduler()
                )
            )
        ).environment(\.colorScheme, .dark)
    }
 }

