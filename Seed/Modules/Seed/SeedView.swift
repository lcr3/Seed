//
//  SeedView.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import ComposableArchitecture
import SwiftUI

struct SeedView: View {
    let store: Store<SeedState, SeedAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView() {
                VStack() {
                    List {
                        Section(header: DialySectionHeader("Dialy", tapAction: {
                            ViewStore(store).send(.addButtonTapped)
                        })) {
                            ForEach(viewStore.state.diaries, id: \.self) { diary in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(diary.title)
                                        .bold()
                                    Text(diary.content)
                                        .font(.caption)
                                        .lineLimit(3)
                                        .foregroundColor(.gray)
                                }
                                .padding(.bottom, 8)
                                .padding(.top, 8)
                            }.onDelete { offsets in
                                let index = offsets.first!
                                ViewStore(store).send(.deleteButtonTapped(index))
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }.onAppear() {
                    ViewStore(store).send(.fetchDiaries)
                }.sheet(isPresented: viewStore.binding(get: { $0.showCreateDiary } , send: SeedAction.showedNewDiary)) {
                    CreateDiaryView(
                        store: Store(
                            initialState: CreateDairyState(),
                            reducer: createDairyReducer,
                            environment: CreateDairyEnvironment(
                                client: FirebaseApiClient.live,
                                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                            )
                        )
                    )
                }
                alert(
                    store.scope(
                        state: { $0.deleteDiaryAlertState.alert },
                        action: SeedAction.deleteAlert
                    ),
                    dismiss: DeleteDiaryAlertAction.dismissAlert
                )
                .navigationTitle("Seed")
            }
        }
    }
}

struct SeedView_Previews: PreviewProvider {
    static var previews: some View {
        SeedView.preview
        SeedView.preview.environment(\.colorScheme, .dark)
    }
}
