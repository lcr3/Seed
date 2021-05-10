//
//  Diary.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import FirebaseFirestoreSwift
import Foundation

struct Diary: Hashable, Equatable, Codable {
    @DocumentID var id: String?
    let title: String
    let content: String
}
