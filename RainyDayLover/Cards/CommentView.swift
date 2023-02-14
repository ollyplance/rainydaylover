//
//  CommentView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 2/5/23.
//

import SwiftUI

struct CommentView: View {
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    Text("Comments")
                        .padding()
                        .font(.system(size: 45, weight: .bold, design: .rounded))
                    
                    VStack {
                        ForEach(0..<3) { i in
                            VStack {
                                HStack {
                                    Circle()
                                        .frame(width: 20, height: 20)
                                    Text("Oliver Lance")
                                }
                                Text("This is the comment....")
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
