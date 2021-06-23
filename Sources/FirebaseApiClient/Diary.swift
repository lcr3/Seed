//
//  Diary.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

public struct Diary: Hashable, Equatable, Codable {
    @DocumentID public var id: String?
    public let title: String
    public let content: String
    public let userId: Int
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case userId = "user_id"
        case createdAt = "created_at"
    }

    public init(id: String? = nil, title: String = "", content: String = "", userId: Int = 0, createdAt: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.userId = userId
        self.createdAt = createdAt
    }
}
