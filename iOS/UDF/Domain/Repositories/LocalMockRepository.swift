//
//  BookMockLocalRepository.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-18.
//

import Foundation

/// A mock repository that simulates local storage using an in-memory array.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `LocalMockRepository` serves as a mock **Side-Effect Gateway**.
/// It is used during development in Xcode Previews and Unit Tests to isolate the UI and Stores from actual SwiftData disk persistence.
@MainActor
class LocalMockRepository: RepositoryProtocol {
    
    /// The in-memory array representing stored books.
    private var books: [Book]
    private var error: RepositoryError?
    
    /// Initializes the mock repository with pre-populated dummy data in debug configurations.
    ///
    /// In UDF, this provides an initial static dataset to facilitate offline UI testing and preview rendering.
    init (error: RepositoryError? = nil) {
        #if DEBUG
            self.books = previewBooks
        #else
            self.books = []
        #endif
        self.error = error
    }
    
    /// Appends a book to the in-memory array.
    ///
    /// - Parameter book: The `Book` to store.
    ///
    /// In UDF, this mock-simulates the database creation side-effect by mutating the local array.
    func create(_ book: Book) throws {
        if self.error == RepositoryError.createFailed {
            throw RepositoryError.createFailed
        }
        books.append(book)
    }
    
    /// Returns the in-memory array of books.
    ///
    /// - Returns: An array of `Book` objects.
    ///
    /// In UDF, this mock-simulates fetching the state from persistent storage.
    func read() async throws -> [Book] {
        if self.error == RepositoryError.readFailed {
            throw RepositoryError.readFailed
        }
        return books
    }
    
    /// Updates the mock book's properties in the array.
    ///
    /// - Parameter book: The `Book` object containing updated values.
    ///
    /// In UDF, this mock-simulates updating a book record.
    func update(_ book: Book) throws {
        if self.error == RepositoryError.updateFailed {
            throw RepositoryError.updateFailed
        }
        if let index = books.firstIndex(of: book) {
            books[index].title = book.title
            books[index].about = book.about
        }
    }
    
    /// Removes a book from the mock in-memory array.
    ///
    /// - Parameter book: The `Book` to remove.
    ///
    /// In UDF, this mock-simulates the database deletion side-effect.
    func delete(_ book: Book) throws {
        if self.error == RepositoryError.deleteFailed {
            throw RepositoryError.deleteFailed
        }
        books.removeAll { $0 == book }
    }
}


#if DEBUG
/// A static array of mock books used to seed `LocalMockRepository` during development and testing.
///
/// In UDF, this provides mock state for previewing the application in Xcode without writing to disk.
var previewBooks = [
    Book(id: UUID(), title: "Test 1", about: "About 1"),
    Book(id: UUID(), title: "Test 2", about: "About 2"),
    Book(id: UUID(), title: "Test 3", about: "About 3"),
    Book(id: UUID(), title: "Test 4", about: "About 4"),
    Book(id: UUID(), title: "Test 5", about: "About 5"),
    Book(id: UUID(), title: "Test 6", about: "About 6"),
    Book(id: UUID(), title: "Test 7", about: "About 7"),
    Book(id: UUID(), title: "Test 8", about: "About 8"),
    Book(id: UUID(), title: "Test 9", about: "About 9"),
    Book(id: UUID(), title: "Test 10", about: "About 10")
]
#endif
