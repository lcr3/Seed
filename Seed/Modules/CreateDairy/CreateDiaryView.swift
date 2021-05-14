//
//  CreateDiaryView.swift
//  Seed
//
//  Created by lcr on 2021/05/09.
//  
//

import ComposableArchitecture
import SwiftUI

struct CreateDiaryView: View {
    @Environment(\.presentationMode) @Binding var presentationMode
    let store: Store<CreateDairyState, CreateDairyAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
                List {
                    HStack() {
                        Text("Title")
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
                        .frame(height: 500)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Write diary")
                .navigationBarItems(trailing: Button("保存", action: {
                    ViewStore(store).send(.create)
                    presentationMode.dismiss()
                }))
        }
    }
}

struct CreateDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDiaryView.preview
        CreateDiaryView.preview.environment(\.colorScheme, .dark)
    }
}
