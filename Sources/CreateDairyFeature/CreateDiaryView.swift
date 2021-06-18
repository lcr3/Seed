//
//  CreateDiaryView.swift
//  Seed
//
//  Created by lcr on 2021/05/09.
//
//

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
                Section(header: Text("Contents")) {
                    TextEditor(
                        text: viewStore.binding(
                            get: \.content,
                            send: CreateDairyAction.changeContent
                        )
                    )
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(
                trailing: Button("保存") {
                    ViewStore(store).send(.create)
                    presentationMode.dismiss()
                }
            ).onAppear {
                if viewStore.state.documentId.isEmpty {
                    viewStore.send(CreateDairyAction.create)
                }
            }
        }
    }
}

//struct CreateDiaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateDiaryView.preview
//        CreateDiaryView.preview.environment(\.colorScheme, .dark)
//    }
//}
