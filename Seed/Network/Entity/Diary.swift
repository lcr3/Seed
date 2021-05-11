//
//  Diary.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Diary: Hashable, Equatable, Codable {
    @DocumentID var id: String?
    let title: String
    let content: String
    let userId: Int
    let createdAt: Timestamp

    enum CodingKeys: String, CodingKey {
        case title
        case content
        case userId = "user_id"
        case createdAt = "created_at"
    }
}
