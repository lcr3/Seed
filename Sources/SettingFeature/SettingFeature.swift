//
//  SettingFeature.swift
//  
//
//  Created by lcr on 2021/06/18.
//  
//

import ComposableArchitecture

public struct SettingState: Equatable {
    public static let defaultFontSizePoint = 0.0
    public var isUseSystemFontSize: Bool
    public var fontSizePoint: Double
    public let fontSizeMaxPoint: Double = 5.0

    public init() {
        isUseSystemFontSize = true
        fontSizePoint = 0.0
    }
}

public enum SettingAction: Equatable {
    case toggleIsUseSystemFontSize
    case sliderFontSizeChanged(Double)
}

public struct SettingEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.mainQueue = mainQueue
    }
}

public let settingReducer = Reducer<SettingState, SettingAction, SettingEnvironment> { state, action, _ in
    switch action {
    case .toggleIsUseSystemFontSize:
        state.isUseSystemFontSize.toggle()
        if state.isUseSystemFontSize {
            state.fontSizePoint = SettingState.defaultFontSizePoint
        }
        return .none
    case let .sliderFontSizeChanged(value):
        state.fontSizePoint = value
        return .none
    }
}
