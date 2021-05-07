//
//  Tag.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import Foundation

struct Tag: Decodable, Identifiable {
    var id = UUID()
    let name: String
}
