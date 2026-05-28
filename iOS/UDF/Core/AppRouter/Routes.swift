//
//  Routes.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-24.
//

import Foundation

/// An enum representing the navigation destinations in the application.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `Route` represents a segment of the **Navigation State**.
/// Views or stores request navigation by passing a `Route` to the `AppRouter`, keeping transitions predictable and centralized.
enum Route: Hashable {
    
    /// The main landing screen displaying the list of books.
    case main
    
    /// The screen containing the form to create a new book.
    case createBookScreen
    
    /// The detail screen for a specific book.
    ///
    /// - Parameter book: The book model entity whose details should be displayed.
    case bookScreen(Book)
}
