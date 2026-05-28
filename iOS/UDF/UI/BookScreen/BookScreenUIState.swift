//
//  BookScreenUIState.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-26.
//

import Foundation

enum BookScreenUIState: BaseUIState {
    case show
    case edit
    case error(String)
    
    static func errorState(message: String) -> BookScreenUIState {
        .error(message)
    }
}
