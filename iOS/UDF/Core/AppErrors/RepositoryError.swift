//
//  RepositoryError.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-26.
//

import Foundation

enum RepositoryError: Error {
    case createFailed
    case readFailed
    case updateFailed
    case deleteFailed
    
    var message: String {
        switch self {
        case .createFailed:
            return "Failed to create in repository"
        case .readFailed:
            return "Failed to read from repository"
        case .updateFailed:
            return "Failed to update in repository"
        case .deleteFailed:
            return "Failed to delete from repository"
        }
    }
}
