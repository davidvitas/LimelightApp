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
    var color: String = "TaskButton"
    @Published var priority: Priority?
    @Published var complete: Complete?
    @Published var category: Category?
    @Published var isComplete: Bool = false
    @Published var isExpanded: Bool = false
    @Published var didMove: Bool = false
    
    var buttonColorHigh: String = "TaskButton"
    var buttonColorMedium: String = "TaskButton"
    var buttonColorLow: String = "TaskButton"
    var buttonColorEndOfDay: String = "TaskButton"
    var buttonColorWithin24Hours: String = "TaskButton"
    
    var buttonColorHome: String = "TaskButton"
    var buttonColorWork: String = "TaskButton"
    
    var textColorHigh: String = "RemainingText"
    var textColorMedium: String = "RemainingText"
    var textColorLow: String = "RemainingText"
    
    var textColorWithin24Hours: String = "RemainingText"
    var textColorEndOfDay: String = "RemainingText"
    
    var textColorHome: String = "RemainingText"
    var textColorWork: String = "RemainingText"
    
    var categorySquareHome: String = "CategorySquare"
    var categorySquareWork: String = "CategorySquare"
    
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
    
    
    init(dateCreated: Date = Date(), title: String = "", description: String = "", priority: Priority? = nil, complete: Complete? = nil, category: Category? = nil) {
        self.dateCreated = dateCreated
        self.title = title
        self.description = description
    }
    
    init(coreData: TaskData) {
        self.dateCreated = coreData.dateCreated
        self.id = coreData.id
        self.description = coreData.taskDescription
        self.title = coreData.title
        self.color = coreData.color
        self.priority = Task.Priority(rawValue: Int(coreData.priority))
        self.complete = Task.Complete(rawValue: coreData.complete ?? "")
        self.category = Task.Category(rawValue: coreData.category ?? "")
        self.isComplete = coreData.isComplete
        self.isExpanded = coreData.isExpanded
        self.didMove = coreData.didMove
        self.buttonColorHigh = coreData.buttonColorHigh
        self.buttonColorMedium = coreData.buttonColorMedium
        self.buttonColorLow = coreData.buttonColorLow
        self.buttonColorEndOfDay = coreData.buttonColorEndOfDay
        self.buttonColorWithin24Hours = coreData.buttonColorWithin24Hours
        self.buttonColorHome = coreData.buttonColorHome
        self.buttonColorWork = coreData.buttonColorWork
        self.textColorHigh = coreData.textColorHigh
        self.textColorMedium = coreData.textColorMedium
        self.textColorLow = coreData.textColorLow
        self.textColorWithin24Hours = coreData.textColorWithin24Hours
        self.textColorEndOfDay = coreData.textColorEndOfDay
        self.textColorHome = coreData.textColorHome
        self.textColorWork = coreData.textColorWork
        self.categorySquareHome = coreData.categorySquareHome
        self.categorySquareWork = coreData.categorySquareWork
    }
    
    func colorAssign() {
        if priority == .high {
            color = "HighPriority"
        } else if priority == .medium {
            color = "MediumPriority"
        } else if priority == .low {
            color = "LowPriority"
        }
    }
    
    func colorChangePriority() {
        switch priority {
        case .high:
            buttonColorHigh = "HighPriority"
            buttonColorMedium = "TaskButton"
            buttonColorLow = "TaskButton"
            textColorHigh = "DateText"
            textColorMedium = "RemainingText"
            textColorLow = "RemainingText"
        case .medium:
            buttonColorMedium = "MediumPriority"
            buttonColorHigh = "TaskButton"
            buttonColorLow = "TaskButton"
            textColorHigh = "RemainingText"
            textColorMedium = "DateText"
            textColorLow = "RemainingText"
        case .low:
            buttonColorLow = "LowPriority"
            buttonColorMedium = "TaskButton"
            buttonColorHigh = "TaskButton"
            textColorHigh = "RemainingText"
            textColorMedium = "RemainingText"
            textColorLow = "DateText"
            
        case nil:
            buttonColorHigh = "TaskButton"
            buttonColorMedium = "TaskButton"
            buttonColorLow = "TaskButton"
            textColorHigh = "RemainingText"
            textColorMedium = "RemainingText"
            textColorLow = "RemainingText"
        }
    }
    
    func colorChangeComplete() {
        switch complete {
        
        case .endOfDay:
            buttonColorEndOfDay = "TaskButtonChosen"
            textColorEndOfDay = "TaskButtonTextChosen"
            buttonColorWithin24Hours = "TaskButton"
            textColorWithin24Hours = "RemainingText"
            
        case .within24Hours:
            buttonColorWithin24Hours = "TaskButtonChosen"
            textColorWithin24Hours = "TaskButtonTextChosen"
            buttonColorEndOfDay = "TaskButton"
            textColorEndOfDay = "RemainingText"
        case nil:
            buttonColorEndOfDay = "TaskButton"
            textColorEndOfDay = "RemainingText"
            buttonColorWithin24Hours = "TaskButton"
            textColorWithin24Hours = "RemainingText"
        }
    }
    
    func colorChangeCategory() {
        switch category {
        
        case .home:
            buttonColorHome = "TaskButtonChosen"
            textColorHome = "TaskButtonTextChosen"
            buttonColorWork = "TaskButton"
            textColorWork = "RemainingText"
            categorySquareHome = "CategorySquareChosen"
            categorySquareWork = "CategorySquare"
            
        case .work:
            buttonColorWork = "TaskButtonChosen"
            textColorWork = "TaskButtonTextChosen"
            buttonColorHome = "TaskButton"
            textColorHome = "RemainingText"
            categorySquareHome = "CategorySquare"
            categorySquareWork = "CategorySquareChosen"

        case nil:
            buttonColorHome = "TaskButton"
            buttonColorWork = "TaskButton"
            textColorHome = "RemainingText"
            textColorWork = "RemainingText"
            categorySquareHome = "CategorySquare"
            categorySquareWork = "CategorySquare"
        }
    }
    
}
