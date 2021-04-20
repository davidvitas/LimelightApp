//
//  ContentView.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-03-30.
//

import SwiftUI

struct ContentView: View {
    @State private var showingNewTaskView = false
    @State private var showingHomeView = true
    
    @State var homeButtonColor: Color = Color("DateBackground")
    @State var listButtonColor: Color = Color("DateBackgroundChosen")
    
    @ObservedObject var taskDate: TaskDate = TaskDate(isActive: true)
    @ObservedObject var taskDateTwo: TaskDate = TaskDate(isActive: false)
    
    @State var dateArrayTest: [TaskDate] = []
    
    var task: Task = Task()
    
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
    
    func taskDateIsActive(dateArray: [TaskDate]) -> TaskDate {
        var isActive: TaskDate = TaskDate(isActive: false)
        for i in dateArray where i.isActive == true {
            isActive = i
        }
        return isActive
    }
    
    var body: some View {
        
        let dateArray: [TaskDate] = [taskDate, taskDateTwo]
        let activeDate = taskDateIsActive(dateArray: dateArray)
        
        NavigationView {
            VStack(alignment: .center) {
                
                VStack {
                    HStack {
                        
                        DateText(date: ContentView.taskDateFormat.string(from: taskDateIsActive(dateArray: dateArray).date))
                        Spacer()
                        OptionsButton()
                    }
                    .padding()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(dateArray) { date in
                                DateView(dateDay: date.shortDateFormatDay.string(from: date.date), dateNumber: date.shortDateFormatNum.string(from: date.date), taskDate: date)
                                    .onTapGesture(perform: {
                                        for i in dateArray {
                                            i.isActive = false
                                        }
                                        date.isActive.toggle()
                                        print(dateArray[0].taskArray)
                                        print(dateArray[1].taskArray)
                                        print(dateArray[0].isActive)
                                        print(dateArray[1].isActive)
                                        
                                    })
                                
                                
                            }
                        }
                        .padding()
                    }
                    .onAppear(perform: {
                        taskDateTwo.date = dayComponent
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
                        TaskTracker()
                        TaskTracker()
                        TaskTracker()
                        TaskTracker()
                        TaskTracker()
                        TaskTracker()
                        TaskTracker()
                        TaskTracker()
                        TaskTracker()
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 15)
                }
                if showingHomeView {
                    HomeView(activeDate: activeDate)
                        .animation(.interactiveSpring())
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        
                        let taskArrayHigh =
                            activeDate.taskArrayPriority(priority: .high)
                        let taskArrayMedium =
                            activeDate.taskArrayPriority(priority: .medium)
                        let taskArrayLow =
                            activeDate.taskArrayPriority(priority: .low)
                        if taskArrayHigh.isEmpty == true && taskArrayMedium.isEmpty == true && taskArrayLow.isEmpty == true {
                                Image("sad-tear")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color("TitleTextHeader"))
                                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            ListHeader(text: "No Tasks")
                        }
                        if taskArrayHigh.isEmpty == false {
                            VStack(alignment: .leading) {
                                ListHeader(text: "High Priority")
                                    .padding(.horizontal)
                                ForEach(taskArrayHigh) { task in
                                    TaskView(taskTitle: task.title, category: task.category?.rawValue ?? "", complete: task.complete?.rawValue ?? "", priorityColor: Color("HighPriority"), task: task)
                                        .padding(.top, 10)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.bottom, 40)
                        }
                        if taskArrayMedium.isEmpty == false {
                            VStack(alignment: .leading) {
                                ListHeader(text: "Medium Priority")
                                    //.padding(.top, 40)
                                    .padding(.horizontal)
                                ForEach(taskArrayMedium) { task in
                                    TaskView(taskTitle: task.title, category: task.category?.rawValue ?? "", complete: task.complete?.rawValue ?? "", priorityColor: Color("MediumPriority"), task: task)
                                        .padding(.top, 10)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.bottom, 40)
                        }
                        if taskArrayLow.isEmpty == false {
                            VStack(alignment: .leading) {
                                ListHeader(text: "Low Priority")
                                    //.padding(.top, 40)
                                    .padding(.horizontal)
                                ForEach(taskArrayLow) { task in
                                    TaskView(taskTitle: task.title, category: task.category?.rawValue ?? "", complete: task.complete?.rawValue ?? "", priorityColor: Color("LowPriority"), task: task)
                                        .padding(.top, 10)
                                        .padding(.horizontal)
                                }
                            }
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
                                destination: NewTaskView(showingNewTaskView: $showingNewTaskView, task: .init(), taskDate: taskDateIsActive(dateArray: dateArray)),
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
