//
//  FirebaseApiClient.swift
//  Seed
//
//  Created by lcr on 2021/05/08.
//  
//

import ComposableArchitecture
import Firebase
import FirebaseFirestoreSwift
import Foundation

struct FirebaseApiClient {
    private static let diaries = "diaries"
    public var fetchDiaries: () -> Effect<[Diary], ApiFailure>
    public var create: (_ diary: Diary) -> Effect<Bool, ApiFailure>
    public var delete: (_ documentId: String) -> Effect<String, ApiFailure>
    public var update: (_ diary: Diary) -> Effect<String, ApiFailure>

    struct ApiFailure: Error, Equatable {
        public let message: String
    }
}

extension FirebaseApiClient {
    public static let live = FirebaseApiClient {
        .future { callback in
            Firestore.firestore().collection(Self.diaries).order(by: "created_at").getDocuments { snapshot, error in
                if let error = error {
                    callback(.failure(.init(message: error.localizedDescription)))
                }
                guard let documents = snapshot?.documents else {
                    return callback(.failure(.init(message: "No documentation found.")))
                }
                var diaries: [Diary] = []
                documents.forEach { content in
                    print(content.data())
                    do {
                        var diary = try Firestore.Decoder().decode(Diary.self, from: content.data())
                        // 明示的に代入しないとnilになる
                        diary.id = content.documentID
                        diaries.append(diary)
                    } catch {
                        callback(.failure(.init(message: error.localizedDescription)))
                    }
                }
                callback(.success(diaries))
            }
        }
    } create: { diary in
        .future { callback in
            Firestore.firestore().collection(Self.diaries).addDocument(data: [
                "title": diary.title,
                "content": diary.content,
                "user_id": 1,
                "created_at": Timestamp(date: Date())
            ]) { error in
                if let error = error {
                    callback(.failure(.init(message: "Create diary error")))
                }
                callback(.success(true))
            }
        }
    } delete: { documentId in
        .future { callback in
            Firestore.firestore().collection(Self.diaries).document(documentId).delete { error in
                if let error = error {
                    callback(.failure(.init(message: "Delete diary error")))
                }
                callback(.success(documentId))
            }
        }
    }
    update: { diary in
        .future { callback in
            Firestore.firestore().collection(Self.diaries).document(diary.id).updateData([
                "title": diary.title,
                "content": diary.content,
                "user_id": diary.userId,
                "created_at": diary.createdAt
            ]) { error in
                if let error = error {
                    callback(.failure(.init(message: "Edit diary error")))
                }
                callback(.success(diary.id))
            }
        }
    }
}
