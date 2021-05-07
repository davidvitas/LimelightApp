//
//  ContentView.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-03-30.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var showingNewTaskView = false
    @State private var showingEditTaskView = false
    @State private var showingHomeView = false
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var homeButtonColor: Color = Color("DateBackground")
    @State var listButtonColor: Color = Color("DateBackgroundChosen")
    
    @ObservedObject var taskDate: TaskDate = TaskDate(isActive: true)
    
    @FetchRequest(
        entity: TaskDateData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TaskDateData.date, ascending: true)
        ]
    ) var dates: FetchedResults<TaskDateData>
    
    @FetchRequest(
        entity: TaskDateData.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TaskDateData.date, ascending: true)
        ], predicate: NSPredicate(format: "isActive = %d", true)
    ) var activeDateData: FetchedResults<TaskDateData>
    
    func addDate() {
        
        //        var isEmpty: Bool {
        //            do {
        //                let request = NSFetchRequest<TaskDateData>(entityName: "TaskDateData")
        //                let count  = try managedObjectContext.count(for: request)
        //                return count == 0
        //            } catch {
        //                return true
        //            }
        //        }
        
        if dates.isEmpty == true {
            let newDate = TaskDateData(context: managedObjectContext)
            let taskDate = TaskDate(isActive: true)
            newDate.id = taskDate.id
            newDate.date = taskDate.date
            newDate.isActive = taskDate.isActive
            PersistenceController.shared.save()
        }
        
        PersistenceController.shared.save()
        
    }
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var dayComponent: Date = {
        var dayComponent = DateComponents()
        dayComponent.day    = 1 // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: Date())
        return nextDate ?? Date()
    }()
    
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
        
        NavigationView {
            VStack(alignment: .center) {
                
                VStack {
                    HStack {
                        let activeDateMap = activeDateData.map { taskDate in
                            TaskDate(taskDateData: taskDate)
                        }
                        DateText(date: ContentView.taskDateFormat.string(from: taskDate.taskDateIsActive(taskDateDataArray: activeDateMap).date))
                        Spacer()
                        OptionsButton()
                    }
                    .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(dates) { dateData in
                                let date = TaskDate(taskDateData: dateData)
                                DateView(dateDay: date.shortDateFormatDay.string(from: date.date), dateNumber: date.shortDateFormatNum.string(from: date.date), taskDate: date)
                                    .onTapGesture(perform: {
                                        for i in dates {
                                            i.isActive = false
                                        }
                                        dateData.isActive.toggle()
                                        PersistenceController.shared.save()
                                    })
                                
                                
                            }
                        }
                        .padding()
                    }
                    .onAppear(perform: {
                        addDate()
                    })
                    
                    HStack(alignment: .center) {
                        HomeTitleText(text: "Daily Tasks")
                        Spacer()
                        HStack(spacing: 4) {
                            listViewButton(icon: "square.grid.2x2", color: homeButtonColor)
                                .onTapGesture {
                                    showingHomeView = true
                                    homeButtonColor = Color("DateBackgroundChosen")
                                    listButtonColor = Color("DateBackground")
                                }
                                .padding(.trailing, 10)
                            listViewButton(icon: "list.bullet", color: listButtonColor)
                                .onTapGesture {
                                    showingHomeView = false
                                    homeButtonColor = Color("DateBackground")
                                    listButtonColor = Color("DateBackgroundChosen")
                                }
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    HStack {
                        ForEach(0...8, id: \.self) { position in
                            let activeDateMap = activeDateData.map { taskDateData in
                                TaskDate(taskDateData: taskDateData)
                            }
                            TaskTracker(activeDate: taskDate.taskDateIsActive(taskDateDataArray: activeDateMap), position: position)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                }
                if showingHomeView {
                    let activeDateMap = activeDateData.map { taskDate in
                        TaskDate(taskDateData: taskDate)
                    }
                    HomeView(activeDate: taskDate.taskDateIsActive(taskDateDataArray: activeDateMap))
                        .animation(.interactiveSpring())
                    Spacer()
                } else {
                    let activeDateMap = activeDateData.map { taskDate in
                        TaskDate(taskDateData: taskDate)
                    }
                    let taskArrayHigh =
                        activeDateMap.first?.taskArrayPriority(priority: .high)
                    let taskArrayMedium =
                        activeDateMap.first?.taskArrayPriority(priority: .medium)
                    let taskArrayLow =
                        activeDateMap.first?.taskArrayPriority(priority: .low)
                    
                    //                    var activeDateDataHigh: [TaskData] {
                    //                        let array: [TaskData] = []
                    //                        for i in activeDateData.first?.taskArray ?? [] where i.priority == 0 {
                    //                            array.append(i)
                    //                        }
                    //                        return array
                    //                    }
                    
                    if taskArrayHigh?.isEmpty == true && taskArrayMedium?.isEmpty == true && taskArrayLow?.isEmpty == true {
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        VStack {
                            Spacer()
                            Image("sad-tear")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("TitleTextHeader"))
                                .frame(width: 50, height: 50, alignment: .center)
                            ListHeader(text: "No Tasks")
                        }
                    }
                    ScrollView(showsIndicators: false) {
                        if taskArrayHigh?.isEmpty == false {
                            VStack(alignment: .leading) {
                                ListHeader(text: "High Priority")
                                    .padding(.horizontal)
                                
                                ForEach(activeDateDataHigh) { taskData in
                                    let task = Task(coreData: taskData)
                                    TaskView(taskTitle: task.title, category: task.category?.rawValue ?? "", complete: task.complete?.rawValue ?? "", priorityColor: Color("HighPriority"), description: task.description, showingEditTaskView: $showingEditTaskView, task: task, taskData: taskData)
                                        .padding(.top, 10)
                                        .padding(.horizontal)
                                }
                            }
                            .animation(.easeOut(duration: 0.25))
                            .padding(.bottom, 40)
                        }
                        if taskArrayMedium?.isEmpty == false {
                            VStack(alignment: .leading) {
                                ListHeader(text: "Medium Priority")
                                    //.padding(.top, 40)
                                    .padding(.horizontal)
                                ForEach(activeDateDataMedium) { taskData in
                                    let task = Task(coreData: taskData)
                                    TaskView(taskTitle: task.title, category: task.category?.rawValue ?? "", complete: task.complete?.rawValue ?? "", priorityColor: Color("MediumPriority"), description: task.description, showingEditTaskView: $showingEditTaskView, task: task, taskData: taskData)
                                        .padding(.top, 10)
                                        .padding(.horizontal)
                                }
                                .animation(.easeOut(duration: 0.25))
                            }
                            .padding(.bottom, 40)
                        }
                        if taskArrayLow?.isEmpty == false {
                            VStack(alignment: .leading) {
                                ListHeader(text: "Low Priority")
                                    .padding(.horizontal)
                                ForEach(activeDateDataLow) { taskData in
                                    let task = Task(coreData: taskData)
                                    TaskView(taskTitle: task.title, category: task.category?.rawValue ?? "", complete: task.complete?.rawValue ?? "", priorityColor: Color("LowPriority"), description: task.description, showingEditTaskView: $showingEditTaskView, task: task, taskData: taskData)
                                        .padding(.top, 10)
                                        .padding(.horizontal)
                                }
                            }
                            .animation(.easeOut(duration: 0.25))
                        }
                    }
                    .padding(.bottom)
                    //.animation(.easeInOut)
                }
                
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundColor(.white)
                        .shadow(color: Color("LightDarkModeShadow"), radius: 20, x: 0, y: -5)
                        .opacity(0.33)
                    Rectangle()
                        .frame(height: 110)
                        .foregroundColor(Color("LightDarkModeBackground"))
                        .overlay (
                            NavigationLink(
                                destination: NewTaskView(taskHeaderTitle: "Create New Task", taskButtonText: "Add Task", showingNewTaskView: $showingNewTaskView, showingEditTaskView: .constant(false), task: Task(), taskTitle: TextLimiter(limit: 25, value: ""), taskDescription: TextLimiter(limit: 110, value: ""), taskData: TaskData()),
                                isActive: $showingNewTaskView,
                                label: {
                                    TaskButton(text: "Create New Task", buttonAction: { showingNewTaskView = true
                                    })
                                    
                                })
                                .padding(.horizontal)
                        )
                }
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView().preferredColorScheme(.dark)
    }
}
