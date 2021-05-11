//
//  Mock.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import ComposableArchitecture
import Firebase
import SwiftUI

extension SeedView {
    static var preview = SeedView(
        store: Store(
            initialState: SeedState(
                deleteDiaryAlertState: DeleteDiaryAlertState(
                documentId: "")
            ),
            reducer: seedReducer,
            environment: SeedEnvironment(
                client: FirebaseApiClient.mock,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
    )
}

extension DialySectionHeader {
    static var preview = Self("Dialy") {
    }
}

extension CreateDiaryView {
    static var preview = CreateDiaryView(
        store: Store(
            initialState: CreateDairyState(),
            reducer: createDairyReducer,
            environment: CreateDairyEnvironment(
                client: FirebaseApiClient.mock,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
    )
}

extension DiaryDetailView {
    static var preview = DiaryDetailView(
        store: Store(
            initialState: DiaryDetailState(
                diary: Diary(
                    id: "documentId",
                    title: "銃・病原菌・鉄",
                    content: "アメリカ大陸の先住民はなぜ、旧大陸の住民に整復されたのか。なぜ、その逆は起こらなかったのか。現在の世界に広がる富とパワーの「地域格差」を生み出したものとは。1万3000年にわたる人類史のダイナミズムに隠された壮大な謎を、進化生物学、生物地理学、文化人類学、言語学など、広範な最新知見を縦横に駆使して解き明かす。ピュリッツァー賞、国際コスモス賞、朝日新聞「ゼロ年代の50冊」第1位を受賞した名著、待望の文庫化",
                    userId: 1,
                    createdAt: Timestamp()
                )
            ),
            reducer: diaryDetailReducer,
            environment: DiaryDetailEnvironment(
                client: FirebaseApiClient.mock,
                mainQueue: DispatchQueue.main.eraseToAnyScheduler()
            )
        )
    )
}

extension FirebaseApiClient {
    public static let mock = FirebaseApiClient {
        .future { callback in
            callback(.success(
                        [
                            Diary(title: "ガリア戦記",
                                  content: "本書は、ローマの政治家であり武将であったカエサルがガリアを平定した戦いの記録である。そこに記されている奇跡的とも言える快進撃は、カエサルの洞察と戦略、そしてリーダーシップによって支えられており、当時の人々を熱狂させただけでなく、現代においても多くの経営者たちに愛読書として読み継がれている。カエサル自身の手による文章は名文の誉れも高く、弁論術で名高いキケローが絶賛するほどである。飾りのない簡潔な文章に始めのうちは味気なさを感じることもあるだろうが、読み進めるにつれ読者はその簡にして要を得た筆致のとりこになることだろう。",
                                  userId: 1,
                                  createdAt: Timestamp()
                            ),
                            Diary(title: "老年とは",
                                  content: "古代ローマ第一の学者にして政治家・弁論家キケロー（前106―前43）が人としての生き方を語り，老年を謳い上げた対話篇．84歳になる古代ローマの政治家・文人大カトーが文武に秀でた二人の若者を屋敷に迎えて，自らの到達した境地から老いと死と生について語る，という構想のもとに進められる．悲観的に，ではなく積極的に老いを語った永遠の古典の新訳．",
                                  userId: 1,
                                  createdAt: Timestamp()
                            ),
                            Diary(title: "饗宴",
                                  content: "原題「シンポシオン」とは「一緒に飲む」というほどの意味．一堂に会した人々が酒盃を重ねつつ興にまかせて次々とエロス（愛）讃美の演説を試みる．談論風発，最後にソクラテスが立ってエロスは肉体の美から精神の美，更に美そのものへの渇望すなわちフィロソフィア（知恵の愛）にまで高まると説く．プラトン対話篇中の最大傑作．",
                                  userId: 1,
                                  createdAt: Timestamp()
                            )
                        ])
            )
        }
    } create: { diary in
        .future { callback in
            callback(.success(true))
        }
    } delete: { documentId in
        .future { callback in
            callback(.success(documentId))
        }
    } update: { diary in
        .future { callback in
            callback(.success(diary.id!))
        }
    }
}
