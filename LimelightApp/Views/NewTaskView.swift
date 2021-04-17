//
//  NewTaskView.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-03-30.
//

import SwiftUI

struct NewTaskView: View {
    @State var taskTitle = ""
    @State var taskDescription = ""
    @State var addTaskDisabled = true
    @Binding var showingNewTaskView: Bool
    @ObservedObject var task: Task
    @ObservedObject var taskDate: TaskDate
    

    
    func enableAddTask() -> Bool {
        if task.title.isEmpty == false && task.description.isEmpty == false && task.priority != nil && task.complete != nil && task.category != nil {
            addTaskDisabled = false
            return false
        }
        return true
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                Rectangle()
                    .foregroundColor(Color("TaskButton"))
                    .cornerRadius(40, corners: [.bottomLeft, .bottomRight])
                
                NewTaskHeader(taskTitle: $taskTitle, buttonAction: {
                    showingNewTaskView = false
                }, task: task)
            }
            .frame(height: 275)

            Spacer()
            VStack(alignment: .leading) {
                TaskTitle(text: "Description")
                    .padding(.leading)
                    .padding(.top)
                
                ZStack(alignment: .leading) {
                    if taskDescription.isEmpty {
                        TextFieldText(text: "add a short description for this task...")
                    }
                    TextField("", text: $taskDescription)
                        .onChange(of: taskDescription, perform: { value in
                            task.description = taskDescription
                        })
                }
                .padding(.leading)
                .padding(.top, 15)
                
                Divider()
                    .frame(height: 1)
                    .background(Color("RemainingText"))
                    .padding(.horizontal)
                
                TaskTitle(text: "Level of Priority")
                    .padding(.leading)
                    .padding(.top)
                
                HStack(spacing: 10) {
                    
                    
                    NewTaskButton(text: "High", buttonColor: task.buttonColorHigh, textColor: task.textColorHigh)
                        .onTapGesture(perform: {
                            task.priority = task.priority == .high ? nil : .high
                            task.colorChangePriority()
                            
                        })
                    Spacer()
                    NewTaskButton(text: "Medium", buttonColor: task.buttonColorMedium, textColor: task.textColorMedium)
                        .onTapGesture(perform: {
                            task.priority = task.priority == .medium ? nil : .medium
                            task.colorChangePriority()
                            
                            
                        })
                    Spacer()
                    NewTaskButton(text: "Low", buttonColor: task.buttonColorLow, textColor: task.textColorLow)
                        .onTapGesture(perform: {
                            task.priority = task.priority == .low ? nil : .low
                            task.colorChangePriority()
                        })
                }
                .padding(.top)
                .padding(.horizontal)
                
                TaskTitle(text: "Complete by")
                    .padding(.leading)
                    .padding(.top)
                
                HStack(spacing: 10) {
                    NewTaskButton(text: "End of Day", buttonColor: task.buttonColorEndOfDay, textColor: task.textColorEndOfDay)
                        .onTapGesture(perform: {
                            task.complete = task.complete == .endOfDay ? nil : .endOfDay
                            task.colorChangeComplete()
                        })
                    Spacer()
                    NewTaskButton(text: "Within 24 Hours", buttonColor: task.buttonColorWithin24Hours, textColor: task.textColorWithin24Hours)
                        .onTapGesture(perform: {
                            task.complete = task.complete == .within24Hours ? nil : .within24Hours
                            task.colorChangeComplete()
                        })
                }
                .padding(.top)
                .padding(.horizontal)
                
                TaskTitle(text: "Category")
                    .padding(.leading)
                    .padding(.top)
                
                HStack(spacing: 10) {
                    NewTaskButton(text: "Home", isCategory: true, buttonColor: task.buttonColorHome, textColor: task.textColorHome, categorySquareColor: task.categorySquareHome)
                        .onTapGesture(perform: {
                            task.category = task.category == .home ? nil : .home
                            task.colorChangeCategory()
                        })
                    Spacer()
                    NewTaskButton(text: "Work", isCategory: true, buttonColor: task.buttonColorWork, textColor: task.textColorWork, categorySquareColor: task.categorySquareWork)
                        .onTapGesture(perform: {
                            task.category = task.category == .work ? nil : .work
                            task.colorChangeCategory()
                        })
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .padding(.vertical)
            VStack {
                
                TaskButton(text: "Add Task", buttonAction: {
//                    taskTitle = task.title
//                    taskDescription = task.description
                    taskDate.taskArray.append(task)
                    showingNewTaskView = false
                    addTaskDisabled = true
                })
                    .padding()
                    .disabled(taskTitle.isEmpty || taskDescription.isEmpty || task.priority == nil || task.complete == nil || task.category == nil)
                    .animation(.easeOut)
                    .buttonStyle(PlainButtonStyle())
                
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
}

struct NewTaskHeader: View {
    @Binding var taskTitle: String
    var buttonAction = {}
    var task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline) {
                TaskHeader(text: "Create New Task")
                    .padding(.top)
                Spacer()
                Button(action: buttonAction ) {
                    Image(systemName: "x.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color("PriorityTextHeader"))
                }
            }
            
            
            TaskTitle(text: "Task Title")
                .padding(.top, 30)
            ZStack(alignment: .leading) {
                if taskTitle.isEmpty {
                    TextFieldText(text: "Add a title for your task...")
                }
                TextField("", text: $taskTitle)
                    .onChange(of: taskTitle, perform: { value in
                        task.title = taskTitle
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
        NewTaskView(showingNewTaskView: .constant(true), task: Task(), taskDate: TaskDate(isActive: false))
        NewTaskView(showingNewTaskView: .constant(true), task: Task(), taskDate: TaskDate(isActive: false))
            .preferredColorScheme(.dark)
    }
}

// cornerRadius extension for individual rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
