//
//  CommunityView.swift
//  AppHerizon
//
//  Created by AFP FED 03 on 16/12/25.
//

import SwiftUI
import PhotosUI

struct CommunityView: View {
    @State private var showMessages = false
    @State private var showCreatePost = false
    @State private var showFilters = false
    @State private var showProfile = false
    
    // Simple post model for demo
    struct Post: Identifiable {
        let id = UUID()
        let userName: String
        let userAvatarSystemImage: String
        let text: String?
        let imageName: String? // system image for placeholder, or asset name
        var liked: Bool
        var saved: Bool
        var commentsCount: Int
        var likesCount: Int
    }
    
    @State private var posts: [Post] = [
        Post(userName: "Alex", userAvatarSystemImage: "person.circle.fill", text: "What a beautiful day to explore the city!", imageName: "photo", liked: false, saved: false, commentsCount: 3, likesCount: 12),
        Post(userName: "Sam", userAvatarSystemImage: "person.circle.fill", text: nil, imageName: "photo", liked: true, saved: false, commentsCount: 1, likesCount: 28),
        Post(userName: "Taylor", userAvatarSystemImage: "person.circle.fill", text: "Just finished a great hike! Any recommendations for next trails?", imageName: nil, liked: false, saved: true, commentsCount: 5, likesCount: 7)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // Controls row
                HStack {
                    // Left: Create Post + plus button
                    HStack(spacing: 8) {
                        Text("Create Post")
                            .font(.headline)
                        Button {
                            showCreatePost = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        }
                        .accessibilityLabel("Create Post")
                    }
                    
                    Spacer()
                    
                    // Right: Filters + filter button
                    HStack(spacing: 8) {
                        Text("Filters")
                            .font(.headline)
                        Button {
                            showFilters = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .imageScale(.large)
                        }
                        .accessibilityLabel("Filters")
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Posts list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(posts.indices, id: \.self) { index in
                            postCard(for: $posts[index])
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Community")
            .toolbar {
                // Leading: Profile avatar (recommended entry point)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showProfile = true
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 28, height: 28)
                            .clipShape(Circle())
                            .foregroundColor(.blue)
                            .accessibilityLabel("Profile")
                    }
                }
                
                // Trailing: Messages button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showMessages = true
                    } label: {
                        Label("Messages", systemImage: "bubble.left.and.bubble.right")
                    }
                    .accessibilityLabel("Messages")
                }
            }
            .navigationDestination(isPresented: $showMessages) {
                MessagesView()
            }
            .navigationDestination(isPresented: $showProfile) {
                ProfileView()
            }
            .sheet(isPresented: $showCreatePost) {
                CreatePostView { newText, pickedImage in
                    // Convert the selected image to a placeholder since your Post uses system image names.
                    // If you later store real images, extend Post to hold a UIImage or URL.
                    let hasImage = pickedImage != nil
                    let newPost = Post(
                        userName: "You",
                        userAvatarSystemImage: "person.circle.fill",
                        text: newText.isEmpty ? nil : newText,
                        imageName: hasImage ? "photo" : nil,
                        liked: false,
                        saved: false,
                        commentsCount: 0,
                        likesCount: 0
                    )
                    posts.insert(newPost, at: 0)
                    showCreatePost = false
                } onCancel: {
                    showCreatePost = false
                }
            }
            .sheet(isPresented: $showFilters) {
                // Simple placeholder for filters UI
                NavigationStack {
                    VStack {
                        Text("Filters")
                            .font(.title2)
                            .padding()
                        Spacer()
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { showFilters = false }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Post Card
    
    @ViewBuilder
    private func postCard(for post: Binding<Post>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: post.wrappedValue.userAvatarSystemImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .foregroundColor(.blue)
                
                Text(post.wrappedValue.userName)
                    .font(.headline)
                
                Spacer()
            }
            
            // Content: text
            if let text = post.wrappedValue.text {
                Text(text)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            // Content: image (placeholder)
            if let imageName = post.wrappedValue.imageName {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.15))
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                    Image(systemName: imageName)
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                }
            }
            
            // Actions
            HStack(spacing: 20) {
                Button {
                    post.wrappedValue.liked.toggle()
                    if post.wrappedValue.liked {
                        post.wrappedValue.likesCount += 1
                    } else {
                        post.wrappedValue.likesCount = max(0, post.wrappedValue.likesCount - 1)
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: post.wrappedValue.liked ? "heart.fill" : "heart")
                            .foregroundColor(post.wrappedValue.liked ? .red : .primary)
                        Text("\(post.wrappedValue.likesCount)")
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
                
                Button {
                    // Handle comments action
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "text.bubble")
                        Text("\(post.wrappedValue.commentsCount)")
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
                
                Button {
                    post.wrappedValue.saved.toggle()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: post.wrappedValue.saved ? "bookmark.fill" : "bookmark")
                        Text(post.wrappedValue.saved ? "Saved" : "Save")
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(.top, 4)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// Placeholder MessagesView to ensure navigation compiles.
// Replace with your real MessagesView implementation.
struct MessagesView: View {
    var body: some View {
        Text("Messages")
            .font(.largeTitle)
            .navigationTitle("Messages")
    }
}

// Simple placeholder ProfileView; replace with your real profile screen.
struct ProfileView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 96, height: 96)
                .foregroundColor(.blue)
            Text("Your Profile")
                .font(.title2)
                .bold()
            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
    }
}

// MARK: - Create Post View

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""
    
    // Optional image picker (PhotosPicker requires iOS 16+)
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    let onPost: (_ text: String, _ image: UIImage?) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.blue)
                    Text("You")
                        .font(.headline)
                }
                
                TextEditor(text: $text)
                    .frame(minHeight: 120)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .overlay(
                        Group {
                            if text.isEmpty {
                                Text("What's on your mind?")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 12)
                                    .allowsHitTesting(false)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    )
                
                if let image = selectedImage {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                        
                        Button {
                            selectedImage = nil
                            selectedItem = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                                .padding(8)
                        }
                    }
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Label(selectedImage == nil ? "Add Photo" : "Change Photo", systemImage: "photo.on.rectangle")
                }
                .onChange(of: selectedItem) { _, newItem in
                    guard let newItem else { return }
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post") {
                        onPost(text, selectedImage)
                        dismiss()
                    }
                    .disabled(text.trimmed().isEmpty && selectedImage == nil)
                }
            }
        }
    }
}

private extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    CommunityView()
}
