//
//  LabelViews.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-03-30.
//

import SwiftUI

struct DateView: View {
    var dateDay: String
    var dateNumber: String
    @ObservedObject var taskDate: TaskDate
    
    var body: some View {
        
        Rectangle()
            .frame(width: 64, height: 72)
            .cornerRadius(28)
            .foregroundColor(taskDate.isActive == true ? Color("DateBackgroundChosen") : Color("DateBackground"))
            .overlay(
                VStack {
                    Text(dateDay.uppercased())
                        .foregroundColor(.white)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .kerning(0.52)
                    Text(dateNumber)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title2)
                        .kerning(0.44)
                }
            )
    }
    
}

struct NewDateView: View {
    var body: some View {
        Rectangle()
            .frame(width: 64, height: 72)
            .cornerRadius(28)
            .foregroundColor(Color("DateBackground"))
            .overlay(
                VStack {
                    Text("NEW")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .kerning(0.52)
                    Image(systemName: "plus")
                }
            )
    }
    
}

struct TaskRect: View {
    var priorityColor: Color
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            Rectangle()
                .foregroundColor(Color("TaskRectangle"))
            Rectangle()
                .frame(width: 8)
                .foregroundColor(priorityColor)
        }
    }
}

struct HomeRect: View {
    var priorityColor: Color
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            Rectangle()
                .frame(height: 77)
                .foregroundColor(Color("TaskRectangle"))
            Rectangle()
                .frame(width: 8, height: 77)
                .foregroundColor(priorityColor)
        }
    }
}

struct DashboardPriorityView: View {
    var priority: String
    var priorityAmount: String
    var listed: Int
    var remaining: Int
    var completed: Int
    var priorityColor: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            HomeRect(priorityColor: priorityColor)
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    ZStack {
                        Circle()
                            .foregroundColor(priorityColor)
                            .frame(width: 41, height: 41)
                        Text(priorityAmount)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.title2)
                            .kerning(0.44)
                        //.offset(x: -0.5)
                    }                    .frame(width: 58, height: 77, alignment: .trailing)
                    .padding(.leading, 9)
                    //Spacer()
                    VStack(alignment: .leading) {
                        Text(priority)
                            .foregroundColor(Color("PriorityTextHeader"))
                            .fontWeight(.semibold)
                            .font(.title3)
                            .kerning(0.4)
                        
                        Text("\(listed) listed / \(remaining) remaining / \(completed) completed")
                            .foregroundColor(Color("RemainingText"))
                            .fontWeight(.regular)
                            .font(.callout)
                            .kerning(0.32)
                            .lineLimit(1)
                        
                    }
                    .padding(.horizontal)
                }
            }
        }
        
    }
}

struct TaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var taskTitle: String
    var category: String
    var complete: String
    var priorityColor: Color
    var description: String
    var duration: Double = 0.25
    @Binding var showingEditTaskView: Bool
    @ObservedObject var task: Task
    @ObservedObject var taskData: TaskData
    @Binding var taskButtonDisabled: Bool
    var dateDataHighSwitch: Bool
    var dateDataMediumSwitch: Bool
    var dateDataLowSwitch: Bool

    @FetchRequest(
        entity: TaskDateData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TaskDateData.date, ascending: true)
        ], predicate: NSPredicate(format: "isActive = %d", true)
    ) var activeDateData: FetchedResults<TaskDateData>
    
    var activeDateDataHigh: [TaskData] {
        var array: [TaskData] = []
        for i in activeDateData.first?.taskArray ?? [] where i.priority == 0 {
            array.append(i)
        }
        return array
    }

    var activeDateDataMedium: [TaskData] {
        var array: [TaskData] = []
        for i in activeDateData.first?.taskArray ?? [] where i.priority == 1 {
            array.append(i)
        }
        return array
    }

    var activeDateDataLow: [TaskData] {
        var array: [TaskData] = []
        for i in activeDateData.first?.taskArray ?? [] where i.priority == 2 {
            array.append(i)
        }
        return array
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            TaskRect(priorityColor: priorityColor)
                .onTapGesture {
                    withAnimation(.easeOut(duration: duration)) {
                        if let activeDateData = activeDateData.first?.taskArray {
                            
                            for i in activeDateData where taskData.id != i.id {
                                i.isExpanded = false
                                PersistenceController.shared.save()
                                managedObjectContext.refreshAllObjects()
                                
                            }
                            taskData.isExpanded.toggle()
                            PersistenceController.shared.save()
                            managedObjectContext.refreshAllObjects()

                        }
                    }
                }
            VStack {
                HStack(alignment: .center) {
                    Button(action: {
                        taskData.isComplete.toggle()
                        PersistenceController.shared.save()
                        
                    }) {
                        ZStack {
                            Circle()
                                .stroke(priorityColor, lineWidth: 2.0)
                                .frame(width: 32, height: 32)
                            if taskData.isComplete {
                                Circle()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(priorityColor)
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 50, height: 77, alignment: .trailing)
                        .padding(.leading, 10)
                        .padding(.trailing, 3)
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        .animation(.easeOut(duration: duration))
                    }
                    .animation(.none)
                    Spacer()
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            HomeText(text: complete)
                            Spacer()
                            HStack {
                                Rectangle()
                                    .foregroundColor(Color("CategorySquare"))
                                    .frame(width: 9, height: 9)
                                Text(category.uppercased())
                                    .foregroundColor(Color("TaskSubtext"))
                                    .font(.caption)
                                    .fontWeight(.regular)
                            }
                        }
                        Text(taskTitle)
                            .foregroundColor(Color("PriorityTextHeader"))
                            .fontWeight(.semibold)
                            .font(.title3)
                            .kerning(0.4)
                            .lineLimit(1)
                    }
                    .padding(.leading, 10)
                    .padding(.trailing)
                }
                if task.isExpanded {
                    HStack {
                        HStack(alignment: .center) {
                            VStack {}
                                .frame(width: 50)
                                .padding(.leading, 10)
                                .padding(.trailing, 3)
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Spacer()
                                }
                                DescriptionText(text: description)
                                    .lineLimit(3)
                            }
                            .padding(.leading, 10)
                            .padding(.trailing)
                        }
                    }
                    .opacity(task.isExpanded ? 1 : 0)
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .animation(.easeOut(duration: duration))
                    
                    HStack {
                        NavigationLink(
                            destination: NewTaskView(taskHeaderTitle: "Edit Task", taskButtonText: "Finish", viewMode: .edit, dateDataHighSwitch: dateDataHighSwitch, dateDataMediumSwitch: dateDataMediumSwitch, dateDataLowSwitch: dateDataLowSwitch, showingNewTaskView: .constant(false), showingEditTaskView: $showingEditTaskView, task: task, taskTitle: TextLimiter(limit: 15, value: task.title), taskDescription: TextLimiter(limit: 100, value: task.description), taskData: taskData),
                            isActive: $showingEditTaskView,
                            label: {
                                TaskEditButton(text: "Edit", buttonAction: {
                                    showingEditTaskView = true
                                })
                            })
                        TaskEditButton(text: "Delete", buttonAction: {
                            taskData.isComplete = false
                            activeDateData.first?.removeFromTaskArraySet(taskData)
                            PersistenceController.shared.save()
                            managedObjectContext.refreshAllObjects()
                        })
                        .onChange(of: activeDateData.first?.taskArray) { _ in
                            if activeDateDataHigh.count <= 0 || activeDateDataMedium.count <= 2 || activeDateDataLow.count <= 4 {
                                
                                
                                taskButtonDisabled = false
                            } else {
                                taskButtonDisabled = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 19)
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .animation(.easeOut(duration: duration))
                }
            }
        }
    }
}

struct TaskButton: View {
    var text: String
    var buttonAction = {}
    
    var body: some View {
        Button(action: buttonAction) {
            Rectangle()
                .frame(height: 48)
                .cornerRadius(20)
                .foregroundColor(Color("TaskButton"))
                .padding(.horizontal)
                .overlay(
                    Text(text.uppercased())
                        .foregroundColor(Color("RemainingText"))
                        .font(.headline)
                        .fontWeight(.bold)
                        .kerning(1.44)
                )
        }
    }
}

struct TaskEditButton: View {
    var text: String
    var buttonAction = {}
    
    var body: some View {
        Button(action: buttonAction) {
            Rectangle()
                .frame(height: 40)
                .cornerRadius(20)
                .foregroundColor(Color("EditTaskButton"))
                .padding(.horizontal)
                .overlay(
                    Text(text.capitalized)
                        .foregroundColor(Color("RemainingText"))
                        .font(.callout)
                        .fontWeight(.semibold)
                        .kerning(1.12)
                )
        }
    }
}

struct OptionsButton: View {
    var buttonAction = {}
    
    var body: some View {
        Button(action: buttonAction) {
            HStack(spacing: 4) {
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(Color("OptionsButton"))
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(Color("OptionsButton"))
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(Color("OptionsButton"))
            }
        }
    }
}

struct NewTaskButton: View {
    var text: String
    var isCategory: Bool = false
    var buttonColor: Color = Color("TaskButton")
    var textColor: Color = Color("RemainingText")
    var categorySquareColor: Color = Color("CategorySquare")
    
    var body: some View {
        if isCategory == false {
            Rectangle()
                .frame(height: 32)
                .cornerRadius(8)
                .foregroundColor(buttonColor)
                //.opacity(0.23)
                .overlay(
                    Text(text.capitalized)
                        .foregroundColor(textColor)
                        .font(.callout)
                        .fontWeight(.regular)
                )
            
        } else {
            Rectangle()
                .frame(height: 32)
                .cornerRadius(8)
                .foregroundColor(buttonColor)
                //.opacity(0.23)
                .overlay(
                    HStack {
                        Rectangle()
                            .foregroundColor(categorySquareColor)
                            .frame(width: 12, height: 12)
                        Text(text.capitalized)
                            .foregroundColor(textColor)
                            .font(.callout)
                            .fontWeight(.regular)
                    })
            
        }
    }
}

struct TaskTracker: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var activeDate: TaskDate
    var position: Int
    
    @FetchRequest(
        entity: TaskDateData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TaskDateData.date, ascending: true)
        ], predicate: NSPredicate(format: "isActive = %d", true)
    ) var activeDateData: FetchedResults<TaskDateData>
    
    @FetchRequest(
        entity: TaskData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TaskData.dateCreated, ascending: true)
        ], predicate: NSPredicate(format: "isComplete = %d", true)
    ) var isCompleteTaskData: FetchedResults<TaskData>
    
    var body: some View {
        
        //let taskTrackerColor = activeDate.taskTrackerColor(onArray: activeDate.taskArray, position: position)
        let taskTrackerColor = isCompleteTaskData.first?.taskDataTrackerColor(onArray: activeDateData, position: position)
        
        Rectangle()
            .frame(height: 8)
            .cornerRadius(8)
            .foregroundColor(Color(taskTrackerColor ?? "TaskButton"))
            .animation(.easeIn(duration: 0.1))
    }
}

struct listViewButton: View {
    var icon: String
    var color: Color
    
    var body: some View {
        Image(systemName: icon)
            .resizable()
            .scaledToFit()
            .frame(width: 22, height: 22)
            .foregroundColor(color)
    }
}

struct LabelViews: View {
    var body: some View {
        VStack {
            
            DashboardPriorityView(priority: "High Priority", priorityAmount: "1", listed: 0, remaining: 2, completed: 3, priorityColor: Color("HighPriority"))
            //.padding()
            TaskButton(text: "Create New Task")
            OptionsButton()
            HStack {
                NewTaskButton(text: "123")
                NewTaskButton(text: "123")
                NewTaskButton(text: "12345", isCategory: true)
            }
            TaskView(taskTitle: "Grocery Shopping", category: "Home", complete: "123", priorityColor: Color("HighPriority"), description: "123wfafwafawf", showingEditTaskView: .constant(false), task: Task(), taskData: TaskData(), taskButtonDisabled: .constant(false), dateDataHighSwitch: false, dateDataMediumSwitch: false, dateDataLowSwitch: false)
            TaskTracker(activeDate: TaskDate(isActive: false), position: 1)
        }
    }
}


struct LabelViews_Previews: PreviewProvider {
    static var previews: some View {
        LabelViews()
        LabelViews().preferredColorScheme(.dark)
    }
}
