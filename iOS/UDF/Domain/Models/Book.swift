//
//  Book.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-18.
//

import Foundation
import SwiftData

/// A SwiftData model representing a book in the library.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `Book` represents the **Domain Model / Entity**.
/// It defines the schema of the persistent state. It is passed between views, repositories, and stores to represent a specific item in the library database.
@Model
final class Book {
    
    /// The unique identifier of the book.
    @Attribute(.unique) var id: UUID
    
    /// The title of the book.
    var title: String
    
    /// A short description or notes about the book.
    var about: String
    
    /// Initializes a new instance of a `Book`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier. Defaults to a newly generated UUID.
    ///   - title: The title of the book.
    ///   - about: A description of the book.
    ///
    /// In UDF, this initializer is used when creating a new book state template to be saved to persistence.
    public init(id: UUID = UUID(), title: String, about: String) {
        self.id = id
        self.title = title
        self.about = about
    }
}
