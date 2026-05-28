//
//  BookScreen.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-21.
//

import SwiftUI

/// A container view displaying the details, edit forms, or delete confirmation dialog for a specific book.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `BookScreen` serves as the **View / Container**.
/// It evaluates UI state flags from the `BookScreenStore` (like `isEditing` or `isDeleteConfirmation`)
/// to render subviews conditionally, binding them to a single source of truth.
struct BookScreen: View {
    
    /// The application router injected via environment to manage screen transitions.
    ///
    /// In UDF, this allows navigation side-effects such as returning to the list screen after deletion.
    @Environment(AppRouter.self) var router
    
    /// The store managing the detail screen's state and action triggers.
    @State var store: BookScreenStore
    
    /// The body of the view, representing the visual components mapping current state flags.
    ///
    /// In UDF, this structure acts as a pure layout mapper of `store.isEditing` and `store.isDeleteConfirmation` states.
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            switch store.uiState {
            case .show:
                HStack {
                    Spacer()
                    Button("Edit") {
                        Task { await store.handle(.edit) }
                    }
                }
                BookScreenDataView(title: store.book.title, about: store.book.about)
            case .edit:
                HStack {
                    Spacer()
                    Button("Cancel") {
                        Task { await store.handle(.cancelEdit) }
                    }
                }
                BookScreenDataEditView(store: store)
            case .error(let message):
                ErrorView(message: message)
            }
            
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding()
        .blur(radius: store.isDeleteConfirmation ? 7 : 0)
        .overlay {
            if store.isDeleteConfirmation {
                BookScreenDeleteConfirmationView(store: store)
            }
        }
    }
    
}

#if DEBUG
#Preview("Success") {
    let bookScreenBook = Book(id: UUID(), title: "test", about: "about")
    let repo = LocalMockRepository()
    let router = AppRouter(repo)
    let bookStore = BookScreenStore(repo, bookScreenBook)
    BookScreen(store: bookStore)
        .environment(router)
}

#Preview("Delete Error") {
    let bookScreenBook = Book(id: UUID(), title: "test", about: "about")
    let repo = LocalMockRepository(error: RepositoryError.deleteFailed)
    let router = AppRouter(repo)
    let bookStore = BookScreenStore(repo, bookScreenBook)
    BookScreen(store: bookStore)
        .environment(router)
}

#Preview("Update Error") {
    let bookScreenBook = Book(id: UUID(), title: "test", about: "about")
    let repo = LocalMockRepository(error: RepositoryError.updateFailed)
    let router = AppRouter(repo)
    let bookStore = BookScreenStore(repo, bookScreenBook)
    BookScreen(store: bookStore)
        .environment(router)
}
#endif
