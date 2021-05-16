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
    init(store: Store<SeedState, SeedAction>) {
        self.store = store
        ViewStore(store).send(.startObserve)
    }
    private var isSearch = false
    let store: Store<SeedState, SeedAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    List {
                        Section {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .padding(.leading, -12)
                                TextField("検索",
                                          text: viewStore.binding(
                                            get: \.searchText,
                                            send: SeedAction.chageSearchText)
                                )
                            }
                            .overlay(
                                HStack {
                                    Spacer()
                                    if viewStore.state.isSearching {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .onTapGesture {
                                                ViewStore(store).send(SeedAction.resetSearchText)
                                            }
                                    }
                                }
                            )
                        }
                        Section(header: HStack {
                            Text("Diary")
                            Spacer()
                            NavigationLink(
                                destination: CreateDiaryView(
                                    store: Store(
                                        initialState: CreateDairyState(),
                                        reducer: createDairyReducer,
                                        environment: CreateDairyEnvironment(
                                            client: FirebaseApiClient.live,
                                            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                                        )
                                    )
                                )
                            ) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.body)
                            }
                        }) {
                            ForEach(viewStore.state.diaries, id: \.self) { diary in
                                NavigationLink(
                                    destination: DiaryDetailView(
                                        store: Store(
                                            initialState: DiaryDetailState(diary: diary),
                                            reducer: diaryDetailReducer,
                                            environment: DiaryDetailEnvironment(
                                                client: FirebaseApiClient.live,
                                                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                                            )
                                        )
                                    )
                                ) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(diary.title)
                                            .bold()
                                        Text(diary.content)
                                            .font(.caption)
                                            .lineLimit(1)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.bottom, 8)
                                    .padding(.top, 8)
                                }
                            }.onDelete { offsets in
                                guard let index = offsets.first else { return }
                                ViewStore(store).send(.deleteButtonTapped(index))
                            }
                        }
                    }.animation(.easeIn)
                    .listStyle(InsetGroupedListStyle())
                }
                .alert(
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
