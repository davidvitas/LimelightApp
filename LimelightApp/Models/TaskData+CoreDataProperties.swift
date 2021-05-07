//
//  TaskData+CoreDataProperties.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-05-06.
//
//

import Foundation
import CoreData


extension TaskData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskData> {
        return NSFetchRequest<TaskData>(entityName: "TaskData")
    }

    @NSManaged public var dateCreated: Date
    @NSManaged public var id: UUID
    @NSManaged public var taskDescription: String
    @NSManaged public var title: String
    @NSManaged public var color: String
    @NSManaged public var priority: Int16
    @NSManaged public var complete: String?
    @NSManaged public var category: String?
    @NSManaged public var isComplete: Bool
    @NSManaged public var isExpanded: Bool
    @NSManaged public var didMove: Bool
    @NSManaged public var buttonColorHigh: String
    @NSManaged public var buttonColorMedium: String
    @NSManaged public var buttonColorLow: String
    @NSManaged public var buttonColorEndOfDay: String
    @NSManaged public var buttonColorWithin24Hours: String
    @NSManaged public var buttonColorHome: String
    @NSManaged public var buttonColorWork: String
    @NSManaged public var textColorHigh: String
    @NSManaged public var textColorMedium: String
    @NSManaged public var textColorLow: String
    @NSManaged public var textColorWithin24Hours: String
    @NSManaged public var textColorEndOfDay: String
    @NSManaged public var textColorHome: String
    @NSManaged public var textColorWork: String
    @NSManaged public var categorySquareHome: String
    @NSManaged public var categorySquareWork: String
    @NSManaged public var taskDateArray: TaskDateData

}

extension TaskData : Identifiable {

}
