//
//  SeedView.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//
//

import Component
import ComposableArchitecture
import CreateDairyFeature
import DiaryDetailFeature
import FirebaseApiClient
import SettingFeature
import SwiftUI

public struct SeedView: View {
    public init(store: Store<SeedState, SeedAction>) {
        self.store = store
        ViewStore(store).send(.startObserve)
    }

    private let store: Store<SeedState, SeedAction>
    private var isSearch = false
    @State var isSetting = false

    public var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    List {
                        Section {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.systemGray)
                                    .padding(.leading, -12)
                                TextField("検索",
                                          text: viewStore.binding(
                                            get: \.searchText,
                                            send: SeedAction.chageSearchText
                                          ))
                            }
                            .overlay(
                                HStack {
                                Spacer()
                                if viewStore.state.isSearching {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.systemGray)
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
                                    store: .init(
                                        initialState: .init(),
                                        reducer: createDairyReducer,
                                        environment: .init(
                                            client: .live,
                                            mainQueue: .main.eraseToAnyScheduler()
                                        )
                                    )
                                )
                            ) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.body)
                            }
                        }) {
                            ForEach(viewStore.state.filteredDiaries, id: \.self) { diary in
                                NavigationLink(
                                    destination: DiaryDetailView(
                                        store: .init(
                                            initialState: .init(diary: diary),
                                            reducer: diaryDetailReducer,
                                            environment: .init(
                                                client: .live,
                                                mainQueue: .main.eraseToAnyScheduler()
                                            )
                                        )
                                    ),
                                    label: {
                                    SeedCell(diary: diary)
                                        .padding(.bottom, 8)
                                        .padding(.top, 8)
                                }
                                )
                                    .contextMenu(
                                        menuItems: {
                                        HStack {
                                            Text(diary.title)
                                            Text(diary.content)
                                        }
                                    }
                                    )
                            }.onDelete { offsets in
                                guard let index = offsets.first else { return }
                                ViewStore(store).send(.deleteButtonTapped(index))
                            }
                        }
                    }.animation(.easeIn)
                        .listStyle(InsetGroupedListStyle())
                }
                .sheet(isPresented: $isSetting) {
                    SettingView(
                        store: .init(
                            initialState: .init(),
                            reducer: settingReducer,
                            environment: .init(
                                mainQueue: .main.eraseToAnyScheduler()
                            )
                        )
                    )
                }
                .navigationBarItems(
                    trailing:
                        Button(action: {
                    isSetting = true
                }) {
                    Image(systemName: "gearshape")
                }
                )
            }
        }
    }

    func didDismiss() {}
}

struct SeedView_Previews: PreviewProvider {
    static var previews: some View {
        SeedView(
            store: .init(
                initialState: SeedState(),
                reducer: seedReducer,
                environment: .init(
                    client: .mock,
                    mainQueue: .main.eraseToAnyScheduler()
                )
            )
        )
        SeedView(
            store: .init(
                initialState: SeedState(),
                reducer: seedReducer,
                environment: .init(
                    client: .mock,
                    mainQueue: .main.eraseToAnyScheduler()
                )
            )
        ).environment(\.colorScheme, .dark)
    }
}
