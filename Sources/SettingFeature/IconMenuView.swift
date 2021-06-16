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

struct AppIcon: Equatable, Identifiable {
    let flavor: IconFlavor
    let thumbnail: String

    public var id = UUID()
}

struct IconMenuState: Equatable {
    var selectedIconFlavor: IconFlavor
    let icons: [AppIcon]

    init(selectedIndex: Int) {
        selectedIconFlavor = .defaultIcon()
        self.icons = [
            AppIcon(
                flavor: .light,
                thumbnail: "LightIcon-60"
            ),
            AppIcon(
                flavor: .dark,
                thumbnail: "DarkIcon-60"
            ),
        ]
    }
}

enum IconMenuAction: Equatable {
    case getSelectedIcon
    case select(IconFlavor)
    case changeIcon(Result<IconFlavor, AppIconError>)
}

struct IconMenuEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var client: AppIconClient
}

let iconMenuReducer = Reducer<IconMenuState, IconMenuAction, IconMenuEnvironment> { state, action, environment in
    switch action {
    case .getSelectedIcon:
        state.selectedIconFlavor = environment.client.iconName
        return .none
    case let .select(flavor):
        return environment.client
            .setIcon(flavor)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(IconMenuAction.changeIcon)
    case let .changeIcon(.success(flavor)):
        state.selectedIconFlavor = flavor
        return .none
    case let .changeIcon(.failure(error)):
        print(error)
        return .none
    }
}

struct IconLabel: View {
    @Binding var text: IconFlavor

    var body: some View {
        HStack {
            Text("App Icon")
                .foregroundColor(.black)
            Spacer()
            Text(text.rawValue)
                .foregroundColor(.systemGray)
            Image(systemName: "chevron.down")
                .foregroundColor(.systemGray)
        }
    }
}

struct IconMenuView: View {
    public init(store: Store<IconMenuState, IconMenuAction>) {
        self.store = store
        ViewStore(store).send(.getSelectedIcon)
    }
    public let store: Store<IconMenuState, IconMenuAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            Picker(
                selection: viewStore.binding(
                    get: \.selectedIconFlavor,
                    send: IconMenuAction.select
                ),
                label: IconLabel(
                    text: viewStore.binding(
                        get: \.selectedIconFlavor,
                        send: IconMenuAction.select
                    )
                )) {
                ForEach(viewStore.state.icons, id: \.id) { icon in
                    VStack {
                        Text(icon.flavor.rawValue)
                        Image(uiImage: UIImage(named: icon.thumbnail)!)
                    }.tag(icon.flavor)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct IconMenuView_Previews: PreviewProvider {
    static var previews: some View {
        IconMenuView(
            store: Store(
                initialState: .init(selectedIndex: 0),
                reducer: iconMenuReducer,
                environment: .init(
                    mainQueue: .main.eraseToAnyScheduler(),
                    client: .live
                )
            )
        )
    }
}
