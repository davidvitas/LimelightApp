//
//  Task.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-04-07.
//

import Foundation
import SwiftUI
import Combine

class Task: ObservableObject, Identifiable {
    var id = UUID()
    var dateCreated: Date
    var title: String
    var description: String
    var color: Color = Color("TaskButton")
    @Published var priority: Priority?
    @Published var complete: Complete?
    @Published var category: Category?
    @Published var isComplete: Bool = false
    @Published var isExpanded: Bool = false
    
    
    var buttonColorHigh: Color = Color("TaskButton")
    var buttonColorMedium: Color = Color("TaskButton")
    var buttonColorLow: Color = Color("TaskButton")
    var buttonColorEndOfDay: Color = Color("TaskButton")
    var buttonColorWithin24Hours: Color = Color("TaskButton")
    
    var buttonColorHome: Color = Color("TaskButton")
    var buttonColorWork: Color = Color("TaskButton")
    
    var textColorHigh: Color = Color("RemainingText")
    var textColorMedium: Color = Color("RemainingText")
    var textColorLow: Color = Color("RemainingText")
    
    var textColorWithin24Hours: Color = Color("RemainingText")
    var textColorEndOfDay: Color = Color("RemainingText")
    
    var textColorHome: Color = Color("RemainingText")
    var textColorWork: Color = Color("RemainingText")
    
    var categorySquareHome: Color = Color("CategorySquare")
    var categorySquareWork: Color = Color("CategorySquare")

    
    init(dateCreated: Date = Date(), title: String = "", description: String = "", priority: Priority? = nil, complete: Complete? = nil, category: Category? = nil) {
        self.dateCreated = dateCreated
        self.title = title
        self.description = description
        self.priority = priority
        self.complete = complete
        self.category = category
    }
    
    func colorAssign() {
        if priority == .high {
            color = Color("HighPriority")
        } else if priority == .medium {
            color = Color("MediumPriority")
        } else if priority == .low {
            color = Color("LowPriority")
        }
    }
    
    func colorChangePriority() {
        switch priority {
        case .high:
            buttonColorHigh = Color("HighPriority")
            buttonColorMedium = Color("TaskButton")
            buttonColorLow = Color("TaskButton")
            textColorHigh = Color("DateText")
            textColorMedium = Color("RemainingText")
            textColorLow = Color("RemainingText")
        case .medium:
            buttonColorMedium = Color("MediumPriority")
            buttonColorHigh = Color("TaskButton")
            buttonColorLow = Color("TaskButton")
            textColorHigh = Color("RemainingText")
            textColorMedium = Color("DateText")
            textColorLow = Color("RemainingText")
        case .low:
            buttonColorLow = Color("LowPriority")
            buttonColorMedium = Color("TaskButton")
            buttonColorHigh = Color("TaskButton")
            textColorHigh = Color("RemainingText")
            textColorMedium = Color("RemainingText")
            textColorLow = Color("DateText")
            
        case nil:
            buttonColorHigh = Color("TaskButton")
            buttonColorMedium = Color("TaskButton")
            buttonColorLow = Color("TaskButton")
            textColorHigh = Color("RemainingText")
            textColorMedium = Color("RemainingText")
            textColorLow = Color("RemainingText")
        }
    }
    
    func colorChangeComplete() {
        switch complete {
        
        case .endOfDay:
            buttonColorEndOfDay = Color("TaskButtonChosen")
            textColorEndOfDay = Color("TaskButtonTextChosen")
            buttonColorWithin24Hours = Color("TaskButton")
            textColorWithin24Hours = Color("RemainingText")
            
        case .within24Hours:
            buttonColorWithin24Hours = Color("TaskButtonChosen")
            textColorWithin24Hours = Color("TaskButtonTextChosen")
            buttonColorEndOfDay = Color("TaskButton")
            textColorEndOfDay = Color("RemainingText")
        case nil:
            buttonColorEndOfDay = Color("TaskButton")
            textColorEndOfDay = Color("RemainingText")
            buttonColorWithin24Hours = Color("TaskButton")
            textColorWithin24Hours = Color("RemainingText")
        }
    }
    
    func colorChangeCategory() {
        switch category {
        
        case .home:
            buttonColorHome = Color("TaskButtonChosen")
            textColorHome = Color("TaskButtonTextChosen")
            buttonColorWork = Color("TaskButton")
            textColorWork = Color("RemainingText")
            categorySquareHome = Color("CategorySquareChosen")
            categorySquareWork = Color("CategorySquare")
            
        case .work:
            buttonColorWork = Color("TaskButtonChosen")
            textColorWork = Color("TaskButtonTextChosen")
            buttonColorHome = Color("TaskButton")
            textColorHome = Color("RemainingText")
            categorySquareHome = Color("CategorySquare")
            categorySquareWork = Color("CategorySquareChosen")

        case nil:
            buttonColorHome = Color("TaskButton")
            buttonColorWork = Color("TaskButton")
            textColorHome = Color("RemainingText")
            textColorWork = Color("RemainingText")
            categorySquareHome = Color("CategorySquare")
            categorySquareWork = Color("CategorySquare")
        }
    }
    
    enum Priority: Int {
        
        case high
        case medium
        case low
    }
    
    enum Complete: String {
        case endOfDay = "By End Of Day"
        case within24Hours = "Within 24 Hours"
    }
    
    enum Category: String {
        case home
        case work
    }
    
}
