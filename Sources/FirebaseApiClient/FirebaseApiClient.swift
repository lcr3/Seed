//
//  FirebaseApiClient.swift
//  Seed
//
//  Created by lcr on 2021/05/08.
//  
//

import Combine
import ComposableArchitecture
import Firebase
import FirebaseFirestoreSwift
import Foundation

public struct FirebaseApiClient {
    private static let diaries = "diaries"
    public var updateSnapshot: () -> Effect<[Diary], ApiFailure>
    public var create: (_ title: String, _ content: String, _ userId: Int) -> Effect<String, ApiFailure>
    public var delete: (_ documentId: String) -> Effect<String, ApiFailure>
    public var update: (_ diary: Diary) -> Effect<String, ApiFailure>

    public struct ApiFailure: Error, Equatable {
        public let message: String
    }
}

public extension FirebaseApiClient {
    static let live = FirebaseApiClient() {
        .run { subscriber in
            Firestore.firestore().collection(Self.diaries).order(by: "created_at").addSnapshotListener { snapshot, error in
                print("update snapshot")
                if let error = error {
                    subscriber.send(
                        completion: .failure(
                            .init(message: error.localizedDescription)
                        )
                    )
                }
                guard let documents = snapshot?.documents else {
                    subscriber.send(
                        completion: .failure(
                            .init(message: "Snapshot is nil.")
                        )
                    )
                    return
                }
                var diaries: [Diary] = []
                documents.forEach { content in
                    do {
                        var diary = try Firestore.Decoder().decode(Diary.self, from: content.data())
                        // 明示的に代入しないとnilになる
                        diary.id = content.documentID
                        diaries.append(diary)
                    } catch {
                        subscriber.send(
                            completion: .failure(
                                .init(message: error.localizedDescription)
                            )
                        )
                    }
                }
                subscriber.send(diaries)
            }
            return AnyCancellable {
                print("cancel")
            }
        }
    } create: { title, content, userId in
        .future { callback in
            var ref: DocumentReference?
            ref = Firestore.firestore().collection(Self.diaries).addDocument(data: [
                "title": title,
                "content": content,
                "user_id": userId,
                "created_at": Timestamp(date: Date())
            ]) { error in
                if let error = error {
                    callback(.failure(.init(message: "Create diary error")))
                }
                if let documentId = ref?.documentID {
                    callback(.success(documentId))
                }
                callback(.failure(.init(message: "Failed create diary")))
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
            guard let documentId = diary.id else {
                callback(.failure(.init(message: "Document id is empty.")))
                return
            }
            Firestore.firestore().collection(Self.diaries).document(documentId).updateData([
                "title": diary.title,
                "content": diary.content,
                "user_id": diary.userId,
                "created_at": diary.createdAt
            ]) { error in
                if let error = error {
                    callback(.failure(.init(message: "Edit diary error")))
                }
                callback(.success(documentId))
            }
        }
    }
}
