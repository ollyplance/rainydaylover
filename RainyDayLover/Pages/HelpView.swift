//
//  HelpView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/18/22.
//

import SwiftUI

struct HelpView: View {
    @Binding var tabSelection: TabBarItem
    @ObservedObject var helpData: HelpData
    @Namespace var namespaceHelp
    @State var show: Bool = false
    @State var selected: Help = Help()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("For when you are:")
                        .padding([.horizontal, .top])
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    Spacer()
                }
                ScrollView {
                    ForEach($helpData.entries) { $data in
                        if !(selected.id == data.id && show) {
                            ZStack {
                                Button(action: {
                                    if (data.unlocked) {
                                        selected = data
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                                            show = true
                                        }
                                    }
                                }) {
                                    HelpCardView(data: $data, show: $show, namespace: namespaceHelp)
                                        .padding(.vertical)
                                }
                                .disabled(!data.unlocked)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                HStack {
                                    Spacer()
                                    UnlockButton(unlocked: $data.unlocked)
                                        .padding(.trailing, 50)
                                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
                                }
                            }
                        } else {
                            HelpCardGhostView()
                                .padding(.vertical)
                        }
                    }
                    .background(Color.white)
                    .listStyle(.plain)
                    .navigationBarTitleDisplayMode(.inline)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("For when you are:")
                            .font(.system(size: 35, weight: .bold, design: .rounded))
                            .padding()
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            if show {
                HelpContentView(data: $selected, show: $show, namespace: namespaceHelp)
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(tabSelection: .constant(.post), helpData: HelpData())
    }
}
