//
//  Date.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-04-07.
//

import Foundation
import Combine
import SwiftUI

class TaskDate: ObservableObject, Identifiable {
    var id = UUID()
    
    @Published var date: Date = Date()
    @Published var taskArray: [Task] = []
    @Published var isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
    }
    
    let shortDateFormatDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    let shortDateFormatNum: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var dayComponent: Date = {
        var dayComponent = DateComponents()
        dayComponent.day    = 1 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        return nextDate ?? Date()
    }()
    
    func taskArrayPriority(priority: Task.Priority) -> [Task] {
        var array: [Task] = []
        for i in taskArray where i.priority == priority {
            array.append(i)
        }
        return array
    }
    
    func taskArrayIsComplete(onArray: [Task], completed: Bool) -> [Task] {
        var array: [Task] = []
        for i in onArray where i.isComplete == completed {
            array.append(i)
        }
        return array
    }
    
    func taskDateIsActive(dateArray: [TaskDate]) -> TaskDate {
        var isActive: TaskDate!
        for i in dateArray where i.isActive == true {
           isActive = i
        }
        return isActive
    }
    
    
    
    
}
