//
//  TextLimiter.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-04-22.
//

import Foundation
import Combine

class TextLimiter: ObservableObject, Equatable {
    
    static func == (lhs: TextLimiter, rhs: TextLimiter) -> Bool {
        return lhs.limit == rhs.limit && lhs.hasReachedLimit == rhs.hasReachedLimit
    }
    
    private let limit: Int
    
    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    
    @Published var hasReachedLimit = false
    
    init(limit: Int, value: String) {
        self.limit = limit
        self.value = value
    }
}
