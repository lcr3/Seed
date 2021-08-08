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

public struct FirebaseApiClient {
    private static let diaries = "diaries"
    public var updateSnapshot: () -> Effect<[Diary], ApiFailure>
    public var create: (_ diary: Diary) -> Effect<String, ApiFailure>
    public var delete: (_ documentId: String) -> Effect<String, ApiFailure>
    public var update: (_ diary: Diary) -> Effect<String, ApiFailure>

    public struct ApiFailure: Error, Equatable {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    public init(updateSnapshot: @escaping () -> Effect<[Diary], ApiFailure>,
                create: @escaping (Diary) -> Effect<String, ApiFailure>,
                delete: @escaping (String) -> Effect<String, ApiFailure>,
                update: @escaping (Diary) -> Effect<String, ApiFailure>) {
        self.updateSnapshot = updateSnapshot
        self.create = create
        self.delete = delete
        self.update = update
    }
}

public extension FirebaseApiClient {
    static let live = FirebaseApiClient {
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
    } create: { diary in
        .future { callback in
            var ref: DocumentReference?
            ref = Firestore.firestore().collection(Self.diaries).addDocument(data: [
                "title": diary.title,
                "type": diary.type,
                "content": diary.content,
                "user_id": diary.userId,
                "created_at": Timestamp(date: Date()),
                "when": diary.when,
                "where": diary.where_,
                "who": diary.who,
                "why": diary.why,
                "how": diary.how,
                "happened": diary.happened,
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
                "created_at": diary.createdAt,
            ]) { error in
                if let error = error {
                    callback(.failure(.init(message: "Edit diary error")))
                }
                callback(.success(documentId))
            }
        }
    }
}

public extension FirebaseApiClient {
    static let mock = FirebaseApiClient {
        .run { subscriber in
            subscriber.send([
                Diary(title: "ガリア戦記",
                      content: "本書は、ローマの政治家であり武将であったカエサルがガリアを平定した戦いの記録である。そこに記されている奇跡的とも言える快進撃は、カエサルの洞察と戦略、そしてリーダーシップによって支えられており、当時の人々を熱狂させただけでなく、現代においても多くの経営者たちに愛読書として読み継がれている。カエサル自身の手による文章は名文の誉れも高く、弁論術で名高いキケローが絶賛するほどである。飾りのない簡潔な文章に始めのうちは味気なさを感じることもあるだろうが、読み進めるにつれ読者はその簡にして要を得た筆致のとりこになることだろう。",
                      userId: 1,
                      createdAt: Date()),
                Diary(title: "寿司屋",
                      content: "",
                      userId: 1,
                      createdAt: Date()),
                Diary(title: "饗宴",
                      content: "原題「シンポシオン」とは「一緒に飲む」というほどの意味．一堂に会した人々が酒盃を重ねつつ興にまかせて次々とエロス（愛）讃美の演説を試みる．談論風発，最後にソクラテスが立ってエロスは肉体の美から精神の美，更に美そのものへの渇望すなわちフィロソフィア（知恵の愛）にまで高まると説く．プラトン対話篇中の最大傑作．",
                      userId: 1,
                      createdAt: Date()),
            ])
            return AnyCancellable {}
        }
    } create: { _ in
        .future { callback in
            callback(.success(""))
        }
    } delete: { documentId in
        .future { callback in
            callback(.success(documentId))
        }
    } update: { diary in
        .future { callback in
            // swiftlint:disable force_unwrapping
            callback(.success(diary.id!))
        }
    }
}
