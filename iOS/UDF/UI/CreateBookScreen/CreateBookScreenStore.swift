//
//  CreateBookScreenStore.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-20.
//

import Foundation
import SwiftUI

/// A store that manages the state and actions of the book creation screen.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `CreateBookScreenStore` serves as the **Store / State Holder**
/// for the creation flow. It holds a draft `Book` entity as its local state, responds to dispatch actions through `handle(_:)`,
/// and delegates persistence commands to the repository.
@Observable
@MainActor
class CreateBookScreenStore: UIStoreProtocol {
    /// The temporary draft of the book being created.
    ///
    /// In UDF, this represents the mutable local state representing form fields input by the user before committing to persistence.
    var book: Book
    
    var uiState: CreateBookScreenUIState = .show
    
    /// The repository used to perform persistent database operations.
    private var repository: RepositoryProtocol
    
    /// Initializes a new store with a given data repository dependency.
    ///
    /// - Parameter repo: The repository acting as the data source and storage pipeline.
    ///
    /// In UDF, this registers the side-effect handler that will process book saving.
    init(_ repo: RepositoryProtocol) {
        self.book = Book(id: UUID(), title: "", about: "")
        repository = repo
    }
    
    /// Processes incoming actions to update state and trigger side-effects.
    ///
    /// - Parameter action: The `CreateBookScreenActions` intent representing the user's action.
    ///
    /// In UDF, this acts as the **Action Handler / Reducer** for book creation. It delegates the persistence side-effect to the repository.
    func handle(_ action: CreateBookScreenActions) async {
        switch action {
        case .createBook:
            await perform {
                try await repository.create(book)
            }
        }
    }
    
    // Removed redundant perform implementation
}
