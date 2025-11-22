//
//  ViewState.swift
//  Ciganus
//
//  Created by Fernando Marins on 11/04/25.
//

import Foundation

enum ViewState<T: Equatable>: Equatable {
    case idle
    case loading
    case success(T)
    case error(String)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
