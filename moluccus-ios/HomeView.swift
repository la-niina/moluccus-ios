//
//  HomeView.swift
//  moluccus-ios
//
//  Created by la niina on 4/7/23.
//
import SwiftUI
import Firebase
import Combine
import UIKit

struct commiting: Codable {
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

typealias ImageCache = NSCache<NSURL, UIImage>

class ViewModel: ObservableObject {
    @Published var commits = [commiting]()

    init() {
        let ref = Database.database().reference().child("moluccus/commits")
        ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }

            var newCommits = [commiting]()
            for (_, data) in value {
                guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []),
                      let commit = try? JSONDecoder().decode(commiting.self, from: jsonData) else { continue }
                newCommits.append(commit)
            }
            self.commits = newCommits
        }
    }
}

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(Color.clear)
                .shadow(radius: 10)
            content
                .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 1)
        )
        .padding(.horizontal, 2)
        .padding(.vertical, 2)
        .padding(.bottom, 2)
        .padding(.vertical, 2)
    }
}

struct CommitCardView: View {
    let commit: commiting
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    if let imageUrl = commit.imageAvatarUrl, let url = URL(string: imageUrl), let imageData = try? Data(contentsOf: url) {
                        Image(uiImage: UIImage(data: imageData) ?? UIImage())
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(commit.timeStamp)
                            .font(.headline)
                        Text(commit.user_name ?? "")
                            .font(.subheadline)
                        Text(commit.user_handle ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                Text(commit.content)
                    .font(.body)
                if let imageUrl = commit.imageUrl, let url = URL(string: imageUrl.first ?? "") {
                    AsyncImage(url: url, placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    })
                    .frame(maxWidth: .infinity, maxHeight: 230)
                    .cornerRadius(20)
                    .padding(.horizontal, 2) // Add horizontal padding
                }
                Spacer()
                HStack {
                    Text("\(commit.likesCount) Likes")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(commit.commentsCount) Comments")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .cornerRadius(8)
        }
    }
}

struct HomeView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.commits, id: \.id) { commit in
                CommitCardView(commit: commit)
                    .padding(.vertical, 0)
                    .padding(.horizontal, 0)
                    .cornerRadius(10)// Add vertical padding to the card
            }
            .padding(.horizontal, 0)
            .listStyle(PlainListStyle())
            .background(Color.clear)
            .navigationTitle("Commits")
        }
    }
}

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image

    init(url: URL, @ViewBuilder placeholder: () -> Placeholder, @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }

    private var content: some View {
        Group {
            if let loadedImage = loader.image {
                image(loadedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                placeholder
            }
        }
    }
}


final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private let url: URL

    init(url: URL) {
        self.url = url
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.image, on: self)
    }

    func load() {
        guard image == nil else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.image, on: self)
    }

    func cancel() {
        cancellable?.cancel()
    }
}
