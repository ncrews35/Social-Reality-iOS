//
//  GridStyles.swift
//  Social-Reality
//
//  Created by Nick Crews on 6/23/21.
//

import SwiftUI

struct ContentGrid: View {
    private var columns: [GridItem] = [
        GridItem(.flexible(minimum: .s0, maximum: 300), spacing: 0),
        GridItem(.flexible(minimum: .s0, maximum: 300), spacing: 0),
        GridItem(.flexible(minimum: .s0, maximum: 300), spacing: 0)
    ] 

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 0,
                pinnedViews: [.sectionHeaders, .sectionFooters]
            ) {
                Section(header: Text("Section 1").font(.title)) {
                    ForEach(0...10, id: \.self) { index in
                        Color.accentColor
                    }
                }

                Section(header: Text("Section 2").font(.title)) {
                    ForEach(11...20, id: \.self) { index in
                        Color.accentColor
                    }
                }
            }
        }
    }
    
}


struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        ContentGrid()
    }
}
