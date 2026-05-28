//
//  BookRepository.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-18.
//

import Foundation
import SwiftData

/// A concrete repository that manages local persistence for books using SwiftData.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `LocalRepository` acts as the **Side-Effect Gateway**.
/// It handles database read and write requests asynchronously, performing the actual state storage operations on the database
/// and returning the results to the Store where the screen state is updated.
@MainActor
final class LocalRepository: RepositoryProtocol {
    
    /// The SwiftData model context used to execute database operations.
    private var modelContext: ModelContext
    
    /// Initializes the repository with a given SwiftData model container.
    ///
    /// - Parameter modelContainer: The SwiftData container containing schema configuration.
    ///
    /// In UDF, this initializes the side-effect handler with the necessary database context.
    init(modelContainer: ModelContainer) {
        modelContext = modelContainer.mainContext
    }
    
    /// Persists a new book in the SwiftData storage.
    ///
    /// - Parameter book: The `Book` model to insert and save.
    ///
    /// In UDF, this is a state mutation side-effect. It writes to disk, ensuring the persistent store stays in sync.
    func create(_ book: Book) async throws {
        modelContext.insert(book)
        do {
            try modelContext.save()
        } catch {
            throw RepositoryError.createFailed
        }
    }
    
    /// Fetches all persisted books from SwiftData, sorted alphabetically by title.
    ///
    /// - Returns: An array of `Book` models fetched from disk, or an empty array if the fetch fails.
    ///
    /// In UDF, this is queried by stores to load list content and populate the UI state.
    func read() async throws -> [Book] {
        let descriptor = FetchDescriptor<Book>(
            predicate: nil,
            sortBy: [.init(\.title, order: .forward)]
        )
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            throw RepositoryError.readFailed
        }
    }
    
    /// Updates properties of an existing book in SwiftData.
    ///
    /// - Parameter book: The `Book` object containing updated fields.
    ///
    /// In UDF, this persists edits made by the user. Once saved to SwiftData, the store is updated to reflect these changes.
    func update(_ book: Book) async throws {
        do {
            let id = book.id
            let descriptor = FetchDescriptor<Book>(predicate: #Predicate<Book> { $0.id == id})
            guard let bookToUpdate = try modelContext.fetch(descriptor).first else { return }
            bookToUpdate.title = book.title
            bookToUpdate.about = book.about
            try modelContext.save()
        } catch {
            throw RepositoryError.updateFailed
        }
    }
    
    /// Deletes a book from the SwiftData storage.
    ///
    /// - Parameter book: The `Book` to delete.
    ///
    /// In UDF, this executes the deletion side-effect, ensuring the record is removed from the database before the UI updates.
    func delete(_ book: Book) async throws {
        do {
            let id = book.id
            let descriptor = FetchDescriptor<Book>(predicate: #Predicate<Book> { $0.id == id})
            guard let bookToDelete = try modelContext.fetch(descriptor).first else { return }
            modelContext.delete(bookToDelete)
            try modelContext.save()
        } catch {
            throw RepositoryError.deleteFailed
        }
    }
}
