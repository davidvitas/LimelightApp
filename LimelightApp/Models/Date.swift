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
    @Published var taskCompletedAmount = 0
    
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
    
    func removeTask(activeDate: TaskDate, activeTask: Task) {
        taskArray.removeAll() {$0.id == activeTask.id}
    }
    
    func taskTrackerColor (onArray: [Task], position: Int) -> Color { // two params, array and position (which dash line from 0 - 8)
        var array = taskArrayIsComplete(onArray: onArray, completed: true) // helper function that returns an array of completed tasks
        var color: Color = Color("TaskButton") // variable to store color
        
        array.sort {
            $0.priority?.rawValue ?? 0 < $1.priority?.rawValue ?? 1 // sorts the array based on high/medium/low priority
        }
        
        let validIndex = array.indices.contains(position) // checks if index exists
        
        switch position { // switches on the dash position
        case 0...8:
            
            if array.isEmpty == false && validIndex == true {
                color = array[position].color
            }
        
        default: color = Color("TaskButton")
        
        }
        
        return color // returns correct color
        
    }
    
}
