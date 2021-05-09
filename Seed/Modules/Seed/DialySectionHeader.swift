//
//  DialySectionHeader.swift
//  Seed
//
//  Created by lcr on 2021/05/09.
//  
//

import SwiftUI

struct DialySectionHeader: View {
    let title: String
    var tapAction: () -> Void

    init(_ title: String, tapAction: @escaping () -> Void) {
        self.title = title
        self.tapAction = tapAction
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Button(action: {
                tapAction()
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .font(.body)
            })
        }
    }
}

struct DialySectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        DialySectionHeader.preview
    }
}
