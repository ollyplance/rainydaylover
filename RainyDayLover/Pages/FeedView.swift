//
//  FeedView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/12/22.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct FeedView: View {
    @ObservedObject var feedData: FeedData
    @ObservedObject var profileData: ProfileData
    @State var firstAppear = true
    @State var showProfile = false
    @Namespace var namespace
    @State var show: Bool = false
    @State var selected: Post = Post()
    var currUID = Auth.auth().currentUser?.uid
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    HStack {
                        Text("Posts")
                            .padding()
                            .font(.system(size: 45, weight: .bold, design: .rounded))
                        Spacer()
                        Button(action: {showProfile.toggle()}) {
                            ProfileView(profile: $profileData.profile, size: 45)
                        }
                        .padding()
                    }
                    LazyVStack {
                        ForEach($feedData.posts) { $post in
                            HStack {
                                if !(selected.id == post.id && show) {
                                    if (post.uid == currUID) {
                                        FootstepsView(post: post)
                                    }
                                    PostCardView(post: $post, show: $show, namespace: namespace)
                                        .shadow(color: Color(post.color), radius: 20, x: 0, y: 15)
                                        .padding(.horizontal)
                                        .modifier(ContextModifier(feedData: feedData, post: post))
                                    if (post.uid != currUID) {
                                        FootstepsView(post: post)
                                    }
                                } else {
                                    if (post.uid == currUID) {
                                        FootstepsView(post: post)
                                    }
                                    PostCardGhostView(post: $post)
                                        .padding(.horizontal)
                                        .modifier(ContextModifier(feedData: feedData, post: post))
                                    if (post.uid != currUID) {
                                        FootstepsView(post: post)
                                    }
                                }
                            }
                            .onAppear {
                                if (post == feedData.posts.last) {
                                    feedData.getNextPosts()
                                }
                            }
                            .onTapGesture {
                                selected = post
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                                    show = true
                                }
                            }
                            .padding(0)
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
                .sheet(isPresented: $showProfile) {
                    SettingsView(profileData: profileData)
                        .presentationDetents([.height(300)])
                }
            }
            if show {
                PostView(post: $selected, show: $show, namespace: namespace)
            }
        }
    }
}

struct FootstepsView: View {
    @State var post: Post
    var body: some View {
        if post.size == "landscape" {
            Image("LandscapeFootsteps")
                .resizable()
                .scaledToFit()
        } else if (post.size == "square") {
            Image("SquareFootsteps")
                .resizable()
                .scaledToFit()
        } else {
            Image("TallFootsteps")
                .resizable()
                .scaledToFit()
        }
    }
}

struct ContextModifier: ViewModifier {
    // ContextMenu Modifier
    @ObservedObject var feedData: FeedData
    var post: Post

    func body(content: Content) -> some View {
        content
            .contextMenu(menuItems: {
                if (post.uid == Auth.auth().currentUser?.uid) {
                    Button(action: {
                        feedData.deletePost(post: post)
                    }) {
                        Text("Delete")
                            .bold()
                            .foregroundColor(Color.red)
                    }
                }
            })
            .contentShape(RoundedRectangle(cornerRadius: 5))
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(feedData: FeedData(), profileData: ProfileData())
    }
}
