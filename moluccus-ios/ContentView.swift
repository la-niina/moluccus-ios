//
//  ContentView.swift
//  moluccus-ios
//
//  Created by la niina on 4/7/23.
//

import SwiftUI
import Firebase

struct Commit: Codable {
    var authorId: String
    var commentsCount: Int
    var content: String
    var id: String
    var imageAvatarUrl: String?
    var imageUrl: [String]?
    var likedByCurrentUser: [String: Bool]?
    var likesCount: Int
    var timeStamp: String
    var user_handle: String?
    var user_name: String?
    var videoUrl: String?
}

struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("home")
                }
                .tag(0)
            SecondView()
                .tabItem {
                    Image(systemName: "book")
                    Text("messages")
                }
                .tag(1)
            ThirdView()
                .tabItem {
                    Image(systemName: "person")
                    Text("notification")
                }
                .tag(2)
            FourthView()
                .tabItem {
                    Image(systemName: "star")
                    Text("profile")
                }
                .tag(3)
        }
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Image(systemName: "book")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("This is the Second View")
        }
        .padding()
    }
}

struct ThirdView: View {
    var body: some View {
        VStack {
            Image(systemName: "person")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("This is the Third View")
        }
        .padding()
    }
}

struct FourthView: View {
    var body: some View {
        VStack {
            Image(systemName: "star")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("This is the Fourth View")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
