//
//  RepositoryProtocol.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-18.
//

import Foundation

/// A protocol defining the storage operations for managing book entities.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, the repository serves as a **Side-Effect Handler / Gateway** to the persistent store (SwiftData).
/// Stores dispatch asynchronous queries or commands to the repository, which performs the request and supplies the resulting data back to the Store to update the state.
protocol RepositoryProtocol {
    
    /// Persists a new book in the database.
    ///
    /// - Parameter book: The `Book` entity to create.
    ///
    /// In UDF, this represents a side-effect command that modifies the underlying persistent state.
    func create(_ book: Book) async throws
    
    /// Retrieves all persisted books.
    ///
    /// - Returns: An array of `Book` entities.
    ///
    /// In UDF, this is used to fetch the initial or updated state from the persistent layer, which is then mapped into the store's state.
    func read() async throws -> [Book]
    
    /// Updates an existing book's details in the database.
    ///
    /// - Parameter book: The `Book` entity to update.
    ///
    /// In UDF, this triggers a persistent update side-effect, ensuring changes are saved before being propagated.
    func update(_ book: Book) async throws
    
    /// Deletes a book from the database.
    ///
    /// - Parameter book: The `Book` entity to delete.
    ///
    /// In UDF, this triggers a deletion side-effect in the persistence layer, altering the source of truth.
    func delete(_ book: Book) async throws
}

