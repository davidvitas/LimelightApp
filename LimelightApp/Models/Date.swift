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
    
    init(taskDateData: TaskDateData) {
        self.id = taskDateData.id
        self.date = taskDateData.date
        self.isActive = taskDateData.isActive
        self.taskArray = taskDateData.taskArray.map { tasks in
            Task(coreData: tasks as TaskData)
        }
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
    
    func minimizeTask(dateArray: [TaskDate]) {
        for i in taskDateIsActive(taskDateDataArray: dateArray).taskArray where i.isExpanded == true{
            i.isExpanded = false
        }
    }
    
    func taskDateIsActive(taskDateDataArray: [TaskDate]) -> TaskDate {
        var isActive: TaskDate = TaskDate(isActive: false)
        for i in taskDateDataArray where i.isActive == true {
            isActive = i
        }
        return isActive
    }
    
    func removeTask(activeDate: TaskDate, activeTask: Task) {
        //withAnimation(.easeInOut(duration: 0.25)) {
            taskArray.removeAll() {$0.id == activeTask.id}
        //}
    }
    
    func taskToMove(onActive: [Task], dateArray: [TaskDate]) {
        var array: [Task] = []
        
        for i in taskArray where i.complete == .within24Hours && i.isComplete == false {
            if Calendar.current.isDate(date, equalTo: i.dateCreated, toGranularity: .day) == false {
                if i.didMove == false {
                    i.didMove = true
                    array.append(i)
                    taskArray.removeAll() {$0.id == i.id}
                    if array.isEmpty == false {
                        for i in array {
                            i.dateCreated = nextDay(date: i.dateCreated)
                        }
                        for date in array {
                            for i in dateArray where date.dateCreated == i.date {
                                i.taskArray.append(date)
                            }
                        }
                        array.removeAll()
                    }
                }
            }
        }
    }
    
    func nextDay(date: Date) -> Date {
        var dayComponent = DateComponents()
        dayComponent.day = 1 // For removing one day (yesterday): -1
        let theCalendar = Calendar.current
        let nextDate = theCalendar.date(byAdding: dayComponent, to: date) ?? Date()
        return nextDate
    }
    
    func taskTrackerColor (onArray: [Task], position: Int) -> String { // two params, array and position (which dash line from 0 - 8)
        var array = taskArrayIsComplete(onArray: onArray, completed: true) // helper function that returns an array of completed tasks
        //var colorString: String = "TaskButton" // variable to store color
        var color: String = "TaskButton" // variable to store color

        
        array.sort {
            $0.priority?.rawValue ?? 0 < $1.priority?.rawValue ?? 1 // sorts the array based on high/medium/low priority
        }
        
        let validIndex = array.indices.contains(position) // checks if index exists
        
        switch position { // switches on the dash position
        case 0...8:
            
            if array.isEmpty == false && validIndex == true {
                color = array[position].color
            }
            
        default: color = "TaskButton"
            
        }
        
        return color // returns correct color
        
    }
    
}
