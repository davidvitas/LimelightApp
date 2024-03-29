//
//  NewTaskView.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-03-30.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var taskHeaderTitle: String
    var taskButtonText: String
    var viewMode: viewModeCase
    var dateDataHighSwitch: Bool
    var dateDataMediumSwitch: Bool
    var dateDataLowSwitch: Bool
    
    @State var addTaskDisabled = true
    @Binding var showingNewTaskView: Bool
    @Binding var showingEditTaskView: Bool
    @ObservedObject var task: Task
    @ObservedObject var taskTitle: TextLimiter
    @ObservedObject var taskDescription: TextLimiter
    var taskData: TaskData?
    
    enum viewModeCase: Int {
        case new
        case edit
    }
    
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
    
    func enableAddTask() -> Bool {
        if task.title.isEmpty == false && task.description.isEmpty == false && task.priority != nil && task.complete != nil && task.category != nil {
            addTaskDisabled = false
            return false
        }
        return true
    }
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    .foregroundColor(Color("TaskButton"))
                    .shadow(color: Color("LightDarkModeShadow").opacity(0.33), radius: 25, x: 0, y: 5)
                if viewMode == .new {
                    NewTaskHeader(taskHeaderTitle: taskHeaderTitle, viewMode: viewMode.rawValue, showingNewTaskView: $showingNewTaskView, taskTitle: taskTitle, buttonAction: {
                        showingNewTaskView = false
                        managedObjectContext.refreshAllObjects()
                    }, task: task)
                    
                } else if viewMode == .edit {
                    NewTaskHeader(taskHeaderTitle: taskHeaderTitle, viewMode: viewMode.rawValue, showingNewTaskView: $showingNewTaskView, taskTitle: taskTitle, task: task)
                    
                }
            }
            .frame(height: 275)
            
            Spacer()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    TaskTitle(text: "Description")
                        .padding(.leading)
                        .padding(.top)
                    
                    ZStack(alignment: .leading) {
                        if taskDescription.value.isEmpty {
                            TextFieldText(text: "add a short description for this task...")
                        }
                        TextField("", text: $taskDescription.value)
                            .onChange(of: taskDescription.value, perform: { value in
                                task.description = taskDescription.value
                            })
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color("RemainingText"))
                        .padding(.horizontal)
                    
                    if dateDataHighSwitch || dateDataMediumSwitch || dateDataLowSwitch {
                        TaskTitle(text: "Level of Priority")
                            .padding(.leading)
                            .padding(.top)
                        
                        HStack(spacing: 10) {
                            if dateDataHighSwitch {
                                NewTaskButton(text: "High", buttonColor: Color(task.buttonColorHigh), textColor: Color(task.textColorHigh))
                                    .onTapGesture(perform: {
                                        task.priority = task.priority == .high ? nil : .high
                                        task.colorChangePriority()
                                        hideKeyboard()
                                    })
                                //Spacer()
                            }
                            if dateDataMediumSwitch {
                                NewTaskButton(text: "Medium", buttonColor: Color(task.buttonColorMedium), textColor: Color(task.textColorMedium))
                                    .onTapGesture(perform: {
                                        task.priority = task.priority == .medium ? nil : .medium
                                        task.colorChangePriority()
                                        hideKeyboard()
                                    })
                            }
                            //Spacer()
                            if dateDataLowSwitch {
                                NewTaskButton(text: "Low", buttonColor: Color(task.buttonColorLow), textColor: Color(task.textColorLow))
                                    .onTapGesture(perform: {
                                        task.priority = task.priority == .low ? nil : .low
                                        task.colorChangePriority()
                                        hideKeyboard()
                                    })
                            }
                        }
                        .padding(.top)
                        .padding(.horizontal)
                    }
                    
                    TaskTitle(text: "Complete by")
                        .padding(.leading)
                        .padding(.top)
                    
                    HStack(spacing: 10) {
                        NewTaskButton(text: "End of Day", buttonColor: Color(task.buttonColorEndOfDay), textColor: Color(task.textColorEndOfDay))
                            .onTapGesture(perform: {
                                task.complete = task.complete == .endOfDay ? nil : .endOfDay
                                task.colorChangeComplete()
                                hideKeyboard()
                            })
                        Spacer()
                        NewTaskButton(text: "Within 24 Hours", buttonColor: Color(task.buttonColorWithin24Hours), textColor: Color(task.textColorWithin24Hours))
                            .onTapGesture(perform: {
                                task.complete = task.complete == .within24Hours ? nil : .within24Hours
                                task.colorChangeComplete()
                                hideKeyboard()
                            })
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    TaskTitle(text: "Category")
                        .padding(.leading)
                        .padding(.top)
                    
                    HStack(spacing: 10) {
                        NewTaskButton(text: "Home", isCategory: true, buttonColor: Color(task.buttonColorHome), textColor: Color(task.textColorHome), categorySquareColor: Color(task.categorySquareHome))
                            .onTapGesture(perform: {
                                task.category = task.category == .home ? nil : .home
                                task.colorChangeCategory()
                                hideKeyboard()
                            })
                        Spacer()
                        NewTaskButton(text: "Work", isCategory: true, buttonColor: Color(task.buttonColorWork), textColor: Color(task.textColorWork), categorySquareColor: Color(task.categorySquareWork))
                            .onTapGesture(perform: {
                                task.category = task.category == .work ? nil : .work
                                task.colorChangeCategory()
                                hideKeyboard()
                            })
                    }
                    .padding(.top)
                    .padding(.horizontal)
                }
                .padding(.vertical)
                if showingNewTaskView {
                    VStack {
                        TaskButton(text: taskButtonText, buttonAction: {
                            task.colorAssign()
                            
                            let taskDataEntry: TaskData = TaskData(context: managedObjectContext)
                            NewTaskMap(task: task, taskData: taskDataEntry)
                            activeDateData.first?.addToTaskArraySet(taskDataEntry)
                            PersistenceController.shared.save()
                            managedObjectContext.refreshAllObjects()
                            
                            showingNewTaskView = false
                            addTaskDisabled = true
                        })
                        .padding()
                        .disabled(taskTitle.value.isEmpty || taskDescription.value.isEmpty || task.priority == nil || task.complete == nil || task.category == nil)
                        .animation(.easeOut(duration: 0.25))
                        .buttonStyle(PlainButtonStyle())
                        //                    .onAppear {
                        //                        priorityButtonDisable()
                        //                    }
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                } else {
                    VStack {
                        TaskButton(text: taskButtonText, buttonAction: {
                            task.colorAssign()
                            task.isExpanded = false
                            NewTaskMap(task: task, taskData: taskData ?? TaskData())
                            PersistenceController.shared.save()
                            managedObjectContext.refreshAllObjects()
                            
                            showingEditTaskView = false
                            addTaskDisabled = true
                        })
                        .padding()
                        .disabled(taskTitle.value.isEmpty || taskDescription.value.isEmpty || task.priority == nil || task.complete == nil || task.category == nil)
                        .animation(.easeOut(duration: 0.25))
                        .buttonStyle(PlainButtonStyle())
                        //                    .onAppear {
                        //                        priorityButtonDisable()
                        //                    }
                    }
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
            }
            .padding(.top, -8)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    func NewTaskMap(task: Task, taskData: TaskData) {
        taskData.dateCreated = task.dateCreated
        taskData.id = task.id
        taskData.taskDescription = task.description
        taskData.title = task.title
        taskData.color = task.color
        taskData.priority = Int16(task.priority?.rawValue ?? 0)
        taskData.complete = task.complete?.rawValue
        taskData.category = task.category?.rawValue
        taskData.isComplete = task.isComplete
        taskData.isExpanded = task.isExpanded
        taskData.didMove = task.didMove
        taskData.buttonColorHigh = task.buttonColorHigh
        taskData.buttonColorMedium = task.buttonColorMedium
        taskData.buttonColorLow = task.buttonColorLow
        taskData.buttonColorEndOfDay = task.buttonColorEndOfDay
        taskData.buttonColorWithin24Hours = task.buttonColorWithin24Hours
        taskData.buttonColorHome = task.buttonColorHome
        taskData.buttonColorWork = task.buttonColorWork
        taskData.textColorHigh = task.textColorHigh
        taskData.textColorMedium = task.textColorMedium
        taskData.textColorLow = task.textColorLow
        taskData.textColorWithin24Hours = task.textColorWithin24Hours
        taskData.textColorEndOfDay = task.textColorEndOfDay
        taskData.textColorHome = task.textColorHome
        taskData.textColorWork = task.textColorWork
        taskData.categorySquareHome = task.categorySquareHome
        taskData.categorySquareWork = task.categorySquareWork
    }
    
    
}

struct NewTaskHeader: View {
    var taskHeaderTitle: String
    var viewMode: Int
    @Binding var showingNewTaskView: Bool
    @ObservedObject var taskTitle: TextLimiter
    var buttonAction = {}
    var task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline) {
                TaskHeader(text: taskHeaderTitle)
                    .padding(.top)
                Spacer()
                if viewMode == 0 {
                    Button(action: buttonAction ) {
                        Image(systemName: "x.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color("PriorityTextHeader"))
                    }
                }
            }
            TaskTitle(text: "Task Title")
                .padding(.top, 30)
            ZStack(alignment: .leading) {
                if taskTitle.value.isEmpty {
                    TextFieldText(text: "Add a title for your task...")
                }
                TextField("", text: $taskTitle.value)
                    .onChange(of: taskTitle.value, perform: { value in
                        task.title = taskTitle.value
                    })
            }
            .padding(.top, 13)
            Divider()
                .frame(height: 1)
                .background(Color("RemainingText"))
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(taskHeaderTitle: "Create New Task", taskButtonText: "", viewMode: .new, dateDataHighSwitch: false, dateDataMediumSwitch: false, dateDataLowSwitch: false, showingNewTaskView: .constant(true), showingEditTaskView: .constant(false), task: Task(), taskTitle: TextLimiter(limit: 25, value: "123"), taskDescription: TextLimiter(limit: 110, value: "123"), taskData: TaskData())
        NewTaskView(taskHeaderTitle: "Create New Task", taskButtonText: "", viewMode: .new, dateDataHighSwitch: false, dateDataMediumSwitch: false, dateDataLowSwitch: false, showingNewTaskView: .constant(true), showingEditTaskView: .constant(false), task: Task(), taskTitle: TextLimiter(limit: 25, value: ""), taskDescription: TextLimiter(limit: 110, value: "1223"), taskData: TaskData())
            .preferredColorScheme(.dark)
    }
}

// cornerRadius extension for individual rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

// Struct used inside extension
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Extension that hides keyboard
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
