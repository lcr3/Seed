//
//  SeedView.swift
//  Seed
//
//  Created by lcr on 2021/05/07.
//  
//

import SwiftUI

struct SeedView: View {
    var article: [Diary] = []

    var body: some View {
        NavigationView() {
            VStack() {
                List {
                    Section(header: DialySectionHeader("Dialy", tapAction: {
                        // send event
                    })) {
                        ForEach(article) { diary in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(diary.title)
                                    .bold()
                                HStack {
                                    // tagださいかも
                                    ForEach(diary.tags) { tag in
                                        Button(action: {
                                            print("Button action")
                                        }) {
                                            HStack {
                                                Text(tag.name)
                                                    .font(.caption2)
                                            }.padding(3)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8.0)
                                                    .stroke(lineWidth: 1.0)
                                            )
                                        }
                                    }
                                }
                                Text(diary.content)
                                    .font(.caption)
                                    .lineLimit(3)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 8)
                            .padding(.top, 8)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

            }.navigationTitle("Seed")
        }
    }

}

struct SeedView_Previews: PreviewProvider {
    static var previews: some View {
        SeedView.preview
        SeedView.preview.environment(\.colorScheme, .dark)
    }
}
