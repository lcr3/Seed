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
    @State private var titleText = ""
    @State private var contentText = ""
    @Environment(\.presentationMode) @Binding var presentationMode
    let store: Store<CreateDairyState, CreateDairyAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView() {
                List {
                    HStack() {
                        Text("Title")
                        TextField("What happened today...", text: $titleText)
                            .multilineTextAlignment(.trailing)
                    }
                    Section(header: Text("Contents")) {
                        TextEditor(text: $contentText)
                            .frame(height: 500)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Write diary")
                .navigationBarItems(trailing: Button("保存", action: {
                    ViewStore(store).send(.create(Diary(title: titleText, content: contentText)))
                }))
            }
            .onChange(of: viewStore.creationCompleted) { completed in
                if completed {
                    presentationMode.dismiss()
                }
            }
        }
    }
}

struct CreateDiaryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDiaryView.preview
        CreateDiaryView.preview.environment(\.colorScheme, .dark)
    }
}
