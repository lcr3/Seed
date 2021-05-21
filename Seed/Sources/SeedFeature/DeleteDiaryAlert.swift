//
//  DeleteDiaryAlert.swift
//  Seed
//
//  Created by lcr on 2021/05/10.
//  
//

import ComposableArchitecture
import Foundation

struct DeleteDiaryAlertState: Equatable {
    var documentId: String
    var alert: AlertState<DeleteDiaryAlertAction>?
}

enum DeleteDiaryAlertAction: Equatable {
    case okButtonTapped
    case cancelButtonTapped
    case dismissAlert
}
