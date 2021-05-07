//
//  TaskDateData+CoreDataProperties.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-05-06.
//
//

import Foundation
import CoreData


extension TaskDateData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskDateData> {
        return NSFetchRequest<TaskDateData>(entityName: "TaskDateData")
    }

    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var isActive: Bool
    @NSManaged public var taskArraySet: NSSet
    
    public var taskArray: [TaskData] {
        let set = taskArraySet as? Set<TaskData> ?? []
        return set.sorted {
            $0.dateCreated < $1.dateCreated
        }
    }

}

// MARK: Generated accessors for taskArraySet
extension TaskDateData {

    @objc(addTaskArraySetObject:)
    @NSManaged public func addToTaskArraySet(_ value: TaskData)

    @objc(removeTaskArraySetObject:)
    @NSManaged public func removeFromTaskArraySet(_ value: TaskData)

    @objc(addTaskArraySet:)
    @NSManaged public func addToTaskArraySet(_ values: NSSet)

    @objc(removeTaskArraySet:)
    @NSManaged public func removeFromTaskArraySet(_ values: NSSet)

}

extension TaskDateData : Identifiable {

}
