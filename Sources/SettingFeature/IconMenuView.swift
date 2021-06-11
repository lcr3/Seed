//
//  IconMenuView.swift
//  
//
//  Created by lcr on 2021/06/11.
//  
//

import Combine
import ComposableArchitecture
import SwiftUI

struct AppIcon: Equatable {
    let index: Int
    let name: String
    let path: String
}

struct IconMenuState: Equatable {
    var selectedIndex: Int
    let icons: [AppIcon]
}

enum IconMenuAction: Equatable {
    case select(Int)
    case changeIcon(Result<String, AppIconError>)
}

struct IconMenuEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var client: AppIconClient
}

let iconMenuReducer = Reducer<IconMenuState, IconMenuAction, IconMenuEnvironment> { state, action, environment in
    switch action {
    case let .select(index):
        state.selectedIndex = index
        let selectIcon = state.icons[index]
        return environment.client
            .setIcon(selectIcon.path)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(IconMenuAction.changeIcon)
    case let .changeIcon(.success(aa)):
        return .none
    case let .changeIcon(.failure(error)):
        print(error)
        return .none
    }
}

struct IconMenuView: View {
    public init(store: Store<IconMenuState, IconMenuAction>) {
        self.store = store
    }
    public let store: Store<IconMenuState, IconMenuAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            Menu {
                ForEach(viewStore.state.icons, id: \.name) { icon in
                    Button {
                        viewStore.send(IconMenuAction.select(icon.index))
                    } label: {
                        Text(icon.name)
                        Image(icon.path)
                    }
                }

            } label: {
                HStack {
                    Text("App Icon")
                        .foregroundColor(.black)
                    Spacer()
                    Text("Dark")
                        .foregroundColor(.systemGray)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.systemGray)
                }
            }
        }
    }
}

struct IconMenuView_Previews: PreviewProvider {
    static var previews: some View {
        IconMenuView(
            store: Store(
                initialState: .init(selectedIndex: 0,
                                    icons: []
                                   ),
                reducer: iconMenuReducer,
                environment: .init(
                    mainQueue: .main.eraseToAnyScheduler(),
                    client: .live
                )
            )
        )
    }
}
