import SwiftUI

struct ChallengeView: View {
    // Top bar
    @Environment(\.dismiss) private var dismiss
    @State private var userName: String = "Alex"
    
    // Tabs/categories
    enum TaskCategory: String, CaseIterable, Identifiable {
        case todo = "To Do"
        case dailies = "Dailies"
        case complete = "Complete"
        var id: String { rawValue }
        
        var symbol: String {
            switch self {
            case .todo: return "square.and.pencil"
            case .dailies: return "sun.max"
            case .complete: return "checkmark.circle"
            }
        }
    }
    
    struct TaskItem: Identifiable {
        let id = UUID()
        let title: String
        var category: TaskCategory
        var selected: Bool
    }
    
    @State private var selectedTab: TaskCategory = .todo
    
    // Initial sample tasks
    @State private var tasks: [TaskItem] = [
        TaskItem(title: "Share your location", category: .todo, selected: true),
        TaskItem(title: "Complete your profile", category: .todo, selected: false),
        TaskItem(title: "Invite a friend", category: .complete, selected: true),
        TaskItem(title: "Walk 5k steps", category: .dailies, selected: false),
        TaskItem(title: "Read 15 minutes", category: .dailies, selected: false)
    ]
    
    // MARK: - Points/progress derived from tasks
    private let pointsPerTask: Int = 10
    
    private var completedCount: Int {
        tasks.filter { $0.selected }.count
    }
    
    private var totalCount: Int {
        tasks.count
    }
    
    private var points: Int {
        completedCount * pointsPerTask
    }
    
    private var maxPoints: Int {
        totalCount * pointsPerTask
    }
    
    private var progress: Double {
        guard maxPoints > 0 else { return 0 }
        return Double(points) / Double(maxPoints)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar at the very top
            topBar
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
            
            // Tabs below the top bar
            TabView(selection: $selectedTab) {
                tabContent(for: .todo)
                    .tabItem { Label(TaskCategory.todo.rawValue, systemImage: TaskCategory.todo.symbol) }
                    .tag(TaskCategory.todo)
                
                tabContent(for: .dailies)
                    .tabItem { Label(TaskCategory.dailies.rawValue, systemImage: TaskCategory.dailies.symbol) }
                    .tag(TaskCategory.dailies)
                
                tabContent(for: .complete)
                    .tabItem { Label(TaskCategory.complete.rawValue, systemImage: TaskCategory.complete.symbol) }
                    .tag(TaskCategory.complete)
            }
        }
    }
    
    // MARK: - Top Bar
    
    private var topBar: some View {
        HStack {
            // Back button
            Button {
                dismiss()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                    Text("Back")
                        .font(.headline)
                }
            }
            
            Spacer()
            
            // Profile icon + name
            HStack(spacing: 8) {
                Button {
                    // Handle profile tapped
                    print("Profile tapped")
                } label: {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.blue)
                        .accessibilityLabel("Profile")
                }
                
                Text(userName)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }
    
    // MARK: - Tab Content
    
    @ViewBuilder
    private func tabContent(for category: TaskCategory) -> some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header: image + points + progress + number
                    HStack(alignment: .center, spacing: 16) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 28, weight: .regular))
                                    .foregroundColor(.gray)
                            )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Points")
                                .font(.headline)
                            
                            ProgressView(value: progress)
                                .progressViewStyle(.linear)
                                .frame(maxWidth: 220)
                            
                            Text("\(points) / \(maxPoints)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Tasks section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Tasks")
                            .font(.title3)
                            .bold()
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            ForEach(filteredIndices(for: category), id: \.self) { index in
                                Button {
                                    tasks[index].selected.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: tasks[index].selected ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(tasks[index].selected ? .green : .gray)
                                            .imageScale(.large)
                                        
                                        Text(tasks[index].title)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text(tasks[index].selected ? "+\(pointsPerTask)" : "+0")
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.secondarySystemBackground))
                                    )
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle(category.rawValue)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Actions") {
                        Button("Select All") {
                            bulkSelect(true, in: category)
                        }
                        Button("Deselect All") {
                            bulkSelect(false, in: category)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func filteredIndices(for category: TaskCategory) -> [Int] {
        tasks.indices.filter { tasks[$0].category == category }
    }
    
    private func bulkSelect(_ selected: Bool, in category: TaskCategory) {
        for i in tasks.indices where tasks[i].category == category {
            tasks[i].selected = selected
        }
    }
}
