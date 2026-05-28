//
//  CreateBookScreenUIState.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-26.
//

import Foundation

enum CreateBookScreenUIState: BaseUIState {
    case show
    case error(String)
    
    static func errorState(message: String) -> CreateBookScreenUIState {
        .error(message)
    }
}
