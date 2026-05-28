//
//  BookScreenStore.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-23.
//

import Foundation
import SwiftData

/// A store that manages the state and actions of the book detail and editing screen.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `BookScreenStore` serves as the **Store / State Holder**
/// for the details view. It encapsulates the detail state (`book`, `isEditing`, `isDeleteConfirmation`), processes actions,
/// coordinates updates with the persistent repository, and updates subscribers upon change.
@Observable
@MainActor
class BookScreenStore: UIStoreProtocol {
    
    /// The book entity whose details are being displayed or modified.
    ///
    /// In UDF, this represents the core domain state on display.
    var book: Book
    
    /// A boolean flag indicating whether the view is in edit mode.
    ///
    /// In UDF, this represents UI layout state that controls switching between display and edit modes.
    var uiState: BookScreenUIState = .show
    
    /// A boolean flag indicating whether the delete confirmation popup should be visible.
    ///
    /// In UDF, this represents presentation state controlling the visibility of the delete dialog.
    var isDeleteConfirmation: Bool = false
    
    /// The repository dependency used to perform persistent database operations.
    private var repo: RepositoryProtocol

    /// Initializes a new store with a given data repository and book model.
    ///
    /// - Parameters:
    ///   - repo: The repository acting as the persistence layer.
    ///   - book: The book model entity instance targeted for detail display.
    ///
    /// In UDF, this binds the store to its subject state and registers side-effect handler dependencies.
    init(_ repo: RepositoryProtocol, _ book: Book) {
        self.repo = repo
        self.book = book
    }
    
    /// Processes incoming actions to update state and trigger side-effects.
    ///
    /// - Parameter action: The `BookScreenActions` intent representing the user's action.
    ///
    /// In UDF, this function acts as the **Action Handler / Reducer** for book details. It mutates local UI state directly
    /// (e.g. toggles editing or deletion flag) or performs asynchronous side-effects (e.g. calling repo update or delete).
    func handle(_ action: BookScreenActions) async {
        switch action {
        case .update(let book):
            await perform {
                try await repo.update(book)
                uiState = .show
            }
        case .showDeleteConfirmation:
            self.isDeleteConfirmation.toggle()
        case .delete:
            await perform({
                try await repo.delete(book)
            }, onFailure: {
                self.isDeleteConfirmation = false
            })
        case .edit:
            uiState = .edit
        case .cancelEdit:
            uiState = .show
        }
    }
}
