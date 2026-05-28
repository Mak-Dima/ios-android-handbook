//
//  MainScreenStore.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-18.
//

import Foundation
import SwiftUI

/// A store that manages the state and actions of the main library screen.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `MainScreenStore` serves as the **Store / State Holder**.
/// It encapsulates the business state (`books` and `uiState`), processes user intents via the ``handle(_:)`` method,
/// communicates with the repository for database operations, and triggers UI updates when properties change.
@Observable
@MainActor
class MainScreenStore: UIStoreProtocol {
    
    /// The collection of books currently loaded for display.
    ///
    /// In UDF, this represents the core business state of the screen.
    var books: [Book]
    
    /// The current visual state of the main screen UI.
    ///
    /// In UDF, this acts as the UI state engine, telling the view whether to render a loader, list, or empty placeholder.
    var uiState: MainScreenUIState = .loading
    
    /// The repository used to perform persistent database operations.
    private var repository: RepositoryProtocol
    
    /// Initializes a new store with a given data repository dependency.
    ///
    /// - Parameter repo: The repository acting as the data source.
    ///
    /// In UDF, this registers the side-effect handler that the store will interact with during action processing.
    init(_ repo: RepositoryProtocol) {
        books = []
        repository = repo
    }
    
    /// Processes incoming actions to update state and trigger side-effects.
    ///
    /// - Parameter action: The `MainScreenActions` intent representing the user's or system's action.
    ///
    /// In UDF, this function acts as the **Action Handler / Reducer**. It intercepts actions, initiates asynchronous
    /// side-effects via the repository, and mutates the store's state property in a single unidirectional direction.
    func handle(_ action: MainScreenActions) async {
        switch action {
        case .read:
            await perform {
                books = try await repository.read()
                books.isEmpty ? (uiState = .empty) : (uiState = .loaded)
            }
        case .delete(book: let book):
            await perform {
                try await repository.delete(book)
                books.removeAll { $0.id == book.id }
                if books.isEmpty {
                    uiState = .empty
                }
            }
        }
    }
}
