//
//  CreateBookScreenActions.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-25.
//

import Foundation

/// An enum defining all user intents that can be dispatched to the book creation screen's store.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `CreateBookScreenActions` represents **Actions / Intents**.
/// The creation screen view dispatches these actions in response to user actions (like pressing the save button)
/// to initiate state saving or mutations.
enum CreateBookScreenActions {
    
    /// Requests the repository to persist the currently configured book.
    ///
    /// In UDF, this action triggers the repository creation side-effect, saving the new book record to SwiftData.
    case createBook
}
