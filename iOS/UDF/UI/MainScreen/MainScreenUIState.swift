//
//  MainScreenUIState.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-25.
//

import Foundation

/// An enum representing the distinct visual states of the main screen.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `MainScreenUIState` acts as the **View State / State Machine**.
/// The screen's layout is dynamically derived from this state: the view reads this state and renders the appropriate layout.
enum MainScreenUIState: BaseUIState {
    
    /// The screen is actively loading data from the repository.
    case loading
    
    /// The screen has successfully loaded the list of books.
    case loaded
    
    /// The screen is empty because there are no books in the library.
    case empty
    
    /// An error occurred during data load or mutation.
    case error(String)
    
    static func errorState(message: String) -> MainScreenUIState {
        .error(message)
    }
}
