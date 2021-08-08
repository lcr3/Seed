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

    public let type: Int
    // type memo
    public let title: String
    public let content: String
    // type ep
    public let when: String
    public let where_: String
    public let who: String
    public let why: String
    public let how: String
    public let happened: String
    // common
    public let userId: Int
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case type
        case title
        case content
        case when
        case where_ = "where"
        case who
        case why
        case how
        case happened
    }

    public init(id: String? = nil,
                title: String = "",
                content: String = "",
                userId: Int = 0,
                createdAt: Date = Date(),
                type: Int = 0,
                when: String = "",
                where_: String = "",
                who: String = "",
                why: String = "",
                how: String = "",
                happened: String = "") {
        self.id = id
        self.title = title
        self.type = type
        self.content = content
        self.userId = userId
        self.createdAt = createdAt
        self.when = when
        self.where_ = where_
        self.who = who
        self.why = why
        self.how = how
        self.happened = happened
    }

    public enum ContentType: Int {
        case memo
        case ep

        public var title: String {
            if self == .memo {
                return "Memo"
            } else {
                return "Episord"
            }
        }

        public var isMemo: Bool {
            return self == .memo
        }
    }

    public func contentType() -> ContentType {
        switch type {
        case 1:
            return .ep
        default:
            return .memo
        }
    }

    public var imageName: String {
        switch self.contentType() {
        case .ep:
            return DiaryImageName.ep
        default:
            return DiaryImageName.memo
        }
    }
}

public struct DiaryImageName {
    public static let ep = "captions.bubble"
    public static let memo = "pencil"
}
