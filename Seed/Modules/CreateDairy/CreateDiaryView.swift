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
            NavigationView() {
                Button("create") {
                    ViewStore(store).send(.create(Diary(title: "", content: "")))
                }
            }.navigationTitle("Write diary")
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
        SeedView.preview.environment(\.colorScheme, .dark)
    }
}
