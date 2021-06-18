//
//  DiaryDetailView.swift
//  
//
//  Created by lcr on 2021/06/18.
//  
//

import ComposableArchitecture
import SwiftUI

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
                Section(header: Text("Contents")) {
                    TextEditor(
                        text: viewStore.binding(
                            get: \.editedContent,
                            send: DiaryDetailAction.editContent
                        )
                    )
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onDisappear {
                viewStore.send(DiaryDetailAction.save)
            }
        }
    }
}

//struct DiaryDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiaryDetailView.preview
//        DiaryDetailView.preview.environment(\.colorScheme, .dark)
//    }
//}
