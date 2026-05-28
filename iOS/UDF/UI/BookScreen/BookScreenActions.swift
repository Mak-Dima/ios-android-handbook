//
//  BookScreenActions.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-23.
//

import Foundation

/// An enum defining all user intents that can be dispatched to the book detail/edit screen's store.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `BookScreenActions` represents **Actions / Intents**.
/// The detail view and its subviews dispatch these actions to update UI states (like editing modes)
/// or trigger database side-effects (like updates and deletions).
enum BookScreenActions {
    
    /// Requests that the specified book's details are saved.
    ///
    /// - Parameter book: The updated `Book` entity containing new values.
    ///
    /// In UDF, this action triggers the repository update side-effect and persists changes.
    case update(Book)
    
    case edit
    case cancelEdit
    
    /// Displays or hides the delete confirmation popup.
    ///
    /// In UDF, this action toggles the boolean visibility flag in the store's screen state.
    case showDeleteConfirmation
    
    /// Requests deletion of the current book from storage.
    ///
    /// In UDF, this action triggers the repository deletion side-effect.
    case delete
}
