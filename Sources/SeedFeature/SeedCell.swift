//
//  File.swift
//  
//
//  Created by lcr on 2021/08/04.
//  
//

import SwiftUI
import FirebaseApiClient


public struct SeedCell: View {
    private let diary: Diary
    
    public init(diary: Diary) {
        self.diary = diary
    }

    public var body: some View {
        if diary.contentType().isMemo() {
            MemoCell(diary: diary)
        } else {
            EpisodeCell(diary: diary)
        }
    }
}

public struct MemoCell: View {
    private let diary: Diary

    public init(diary: Diary) {
        self.diary = diary
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: diary.imageName)
                    .font(.caption)
                Text(diary.title)
                    .bold()
            }
            Text(diary.content)
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.gray)
        }
    }
}

public struct EpisodeCell: View {
    private let diary: Diary

    public init(diary: Diary) {
        self.diary = diary
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: diary.imageName)
                    .font(.caption)
                Text(diary.title)
                    .bold()
            }
        }
    }
}

struct CellViews_Previews: PreviewProvider {
    static var memoDary = Diary(title: "memo", content: "content")
    static var episordDary = Diary(title: "episord", content: "content")
    static var previews: some View {
        MemoCell(diary: Self.memoDary)
        EpisodeCell(diary: Self.episordDary)
    }
}
