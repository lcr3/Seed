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
    public var fetchDiaries: () -> Effect<[Diary], ApiFailure>
    public var create: (Diary) -> Effect<Bool, ApiFailure>

    struct ApiFailure: Error, Equatable {
        let message: String
    }
}

extension FirebaseApiClient {
    public static let live = FirebaseApiClient {
        .future { callback in
            Firestore.firestore().collection("diaries").getDocuments { snapshot, error in
                if let error = error {
                    callback(.failure(ApiFailure(message: error.localizedDescription)))
                }
                guard let documents = snapshot?.documents else {
                    return callback(.failure(ApiFailure(message: "No documentation found.")))
                }
                var diaries: [Diary] = []
                documents.forEach { content in
                    do {
                        let diary = try Firestore.Decoder().decode(Diary.self, from: content.data())
                        diaries.append(diary)
                    } catch {
                        callback(.failure(ApiFailure(message: error.localizedDescription)))
                    }
                }
                callback(.success(diaries))
            }
        }
    } create: { diary in
        .future { callback in
            Firestore.firestore().collection("diaries").addDocument(data: [
                "title": diary.title,
                "content": diary.content,
                "user_id": 1,
                "created_at": Timestamp(date: Date())
            ]) { error in
                if let error = error {
                    callback(.failure(ApiFailure.init(message: "create diary error")))
                }
                callback(.success(true))
            }
        }
    }

    public static let mock = FirebaseApiClient {
        .future { callback in
            callback(.success(
                [
                    Diary(title: "ガリア戦記",
                          content: "本書は、ローマの政治家であり武将であったカエサルがガリアを平定した戦いの記録である。そこに記されている奇跡的とも言える快進撃は、カエサルの洞察と戦略、そしてリーダーシップによって支えられており、当時の人々を熱狂させただけでなく、現代においても多くの経営者たちに愛読書として読み継がれている。カエサル自身の手による文章は名文の誉れも高く、弁論術で名高いキケローが絶賛するほどである。飾りのない簡潔な文章に始めのうちは味気なさを感じることもあるだろうが、読み進めるにつれ読者はその簡にして要を得た筆致のとりこになることだろう。"
                    ),
                    Diary(title: "老年とは",
                          content: "古代ローマ第一の学者にして政治家・弁論家キケロー（前106―前43）が人としての生き方を語り，老年を謳い上げた対話篇．84歳になる古代ローマの政治家・文人大カトーが文武に秀でた二人の若者を屋敷に迎えて，自らの到達した境地から老いと死と生について語る，という構想のもとに進められる．悲観的に，ではなく積極的に老いを語った永遠の古典の新訳．"
                    ),
                    Diary(title: "饗宴",
                          content: "原題「シンポシオン」とは「一緒に飲む」というほどの意味．一堂に会した人々が酒盃を重ねつつ興にまかせて次々とエロス（愛）讃美の演説を試みる．談論風発，最後にソクラテスが立ってエロスは肉体の美から精神の美，更に美そのものへの渇望すなわちフィロソフィア（知恵の愛）にまで高まると説く．プラトン対話篇中の最大傑作．"
                    )
                ])
            )
        }
    } create: { diary in
        .future { callback in
            callback(.success(true))
        }
    }
}
