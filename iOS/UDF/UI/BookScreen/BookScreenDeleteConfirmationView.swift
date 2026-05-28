//
//  DeleteConfirmationView.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-23.
//

import SwiftUI

/// A confirmation dialog view prompting the user to confirm or cancel the deletion of a book.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `BookScreenDeleteConfirmationView` serves as a component of the **View**.
/// When the user confirms deletion, it dispatches the `.delete` action to execute the persistent deletion side-effect
/// and uses the router to navigate back. Tapping cancel dispatches `.showDeleteConfirmation` to toggle the visibility flag.
struct BookScreenDeleteConfirmationView: View {
    
    /// The application router injected via environment to manage screen transitions.
    ///
    /// In UDF, this coordinates popping back to the list screen upon successful deletion.
    @Environment(AppRouter.self) var router
    
    /// The store managing the screen's state and actions.
    var store: BookScreenStore
    
    /// The body of the view, laying out the confirmation prompt and action buttons.
    ///
    /// In UDF, this presents controls that dispatch intents back to the store, ensuring unidirectional data and event flow.
    var body: some View {
        VStack {
            Text("Are you sure you want to delete this book?")
            
            Divider()
            
            HStack {
                Button("Delete") {
                    Task {
                        await store.handle(.delete)
                        router.navigateBack()
                    }
                }
                
                Spacer()

                Button("Cancel") {
                    Task { await store.handle(.showDeleteConfirmation) }
                }
                .padding()
            }
            .padding()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black, radius: 50, x: 0, y: 0)
        .padding()
    }
}

#if DEBUG
#Preview {
    let store = BookScreenStore(
        LocalMockRepository(),
        Book(id: UUID(), title: "Test", about: "About")
    )
    let router = AppRouter(LocalMockRepository())
    
    BookScreenDeleteConfirmationView(store: store)
        .environment(router)
}
#endif
