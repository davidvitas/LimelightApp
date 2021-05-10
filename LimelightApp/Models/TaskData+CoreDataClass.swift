//
//  TaskData+CoreDataClass.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-05-06.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(TaskData)
public class TaskData: NSManagedObject {
    
    func taskDataTrackerColor (onArray: FetchedResults<TaskDateData>, position: Int) -> String { // two params, array and position (which dash line from 0 - 8)
        var array: [TaskData] = [] // helper function that returns an array of completed tasks
        if let taskData = onArray.first?.taskArray {
            for i in taskData where i.isComplete == true {
                array.append(i)
            }
        }
        //var colorString: String = "TaskButton" // variable to store color
        var color: String = "TaskButton" // variable to store color
        
        array.sort {
            $0.priority < $1.priority // sorts the array based on high/medium/low priority
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
