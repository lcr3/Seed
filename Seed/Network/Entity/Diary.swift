//
//  Diary.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import Foundation

struct Diary: Decodable, Identifiable {
    var id = UUID()
    let title: String
    let content: String
    let tags: [Tag]
}
