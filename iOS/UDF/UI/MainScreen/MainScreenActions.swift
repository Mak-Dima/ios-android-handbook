//
//  MainScreenAction.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-18.
//

import Foundation

/// An enum defining all user and system intents that can be dispatched to the main screen's store.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `MainScreenActions` represents **Actions / Intents**.
/// The view triggers these actions in response to user events (like deleting a row) or life-cycle hooks (like loading on appearance).
/// The store processes these actions to update the state or execute side-effects.
enum MainScreenActions {
    
    /// Requests the repository to load the list of books.
    ///
    /// In UDF, this action triggers the repository fetch side-effect, which then updates the store state with the loaded data.
    case read
    
    /// Requests deletion of a specific book.
    ///
    /// - Parameter book: The book model entity targeted for deletion.
    ///
    /// In UDF, this action triggers the persistent deletion side-effect and updates the locally held state list.
    case delete(book: Book)
}
