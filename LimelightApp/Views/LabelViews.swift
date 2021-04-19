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
                .frame(height: 77)
                //.frame(minWidth: 355, idealWidth: 370, maxWidth: 370)
                .foregroundColor(Color("TaskRectangle"))
            Rectangle()
                .frame(width: 8, height: 77)
                .foregroundColor(priorityColor)
        }
    }
}

struct TaskRectOpen: View {
    var priorityColor: Color
    var heightValue: CGFloat
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            Rectangle()
                .frame(height: heightValue)
                //.frame(minWidth: 355, idealWidth: 370, maxWidth: 370)
                .foregroundColor(Color("TaskRectangle"))
            Rectangle()
                .frame(height: 8)
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
            TaskRect(priorityColor: priorityColor)
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
    var taskTitle: String
    var category: String
    var complete: String
    var priorityColor: Color
    @ObservedObject var task: Task

    
    var body: some View {
        TaskRect(priorityColor: priorityColor)
            .overlay(
                HStack(alignment: .center) {
                    ZStack {
                        Circle()
                            .stroke(priorityColor, lineWidth: 2.0)
                            .frame(width: 32, height: 32)
//                            .onTapGesture(perform: {
//                                task.isComplete.toggle()
//                            })
                        if task.isComplete == true {
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
                    .onTapGesture(perform: {
                        task.isComplete.toggle()
                    })
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
                    }
                    .padding(.leading, 10)
                    .padding(.trailing)
                    
                    
                }
            )
    }
}

struct TaskViewOpen: View {
    var task: String
    var category: String
    var remaining: Int
    var completed: Int
    var rectHeight: CGFloat = 234
    
    var body: some View {
        ZStack(alignment: .top) {
            TaskRectOpen(priorityColor: Color("HighPriority"), heightValue: rectHeight)
            VStack(spacing: 1) {
                HStack(alignment: .center) {
                        ZStack {
                            Circle()
                                .stroke(Color("HighPriority"), lineWidth: 2.0)
                                .frame(width: 32, height: 32)
                            
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color("HighPriority"))
                            
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                        }
                        .frame(width: 50, height: 77, alignment: .trailing)
                        .padding(.leading, 10)
                        .padding(.trailing, 3)
                        Spacer()
                        
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            HStack {
                                HomeText(text: "By end of day")
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
                            
                            Text(task)
                                .foregroundColor(Color("PriorityTextHeader"))
                                .fontWeight(.semibold)
                                .font(.title3)
                                .kerning(0.4)
                        }
                        .padding(.leading, 10)
                        .padding(.trailing)
                        
                        
                    }
                .padding(.top, 7)
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
                                DescriptionText(text: "Pick up from Whole Foods: bananas, oat milk, avocados, and ingredients for pasta; Pick up from Walmart: kitchen towels, ")
                            }
                            .padding(.leading, 10)
                            .padding(.trailing)
                        }
                }
                HStack {
                    TaskEditButton(text: "Edit")
                    TaskEditButton(text: "Delete")
                }
                .padding(.horizontal)
                .padding(.vertical, 23)
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
    var body: some View {
        Rectangle()
            .frame(height: 8)
            .cornerRadius(8)
            .foregroundColor(Color("TaskTracker"))
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
            HStack {
                //DateView(dateDay: "MON", dateNumber: "25")
                NewDateView()
            }
            TaskRect(priorityColor: Color("HighPriority"))
            DashboardPriorityView(priority: "High Priority", priorityAmount: "1", listed: 0, remaining: 2, completed: 3, priorityColor: Color("HighPriority"))
            //.padding()
            TaskButton(text: "Create New Task")
            OptionsButton()
            HStack {
                NewTaskButton(text: "123")
                NewTaskButton(text: "123")
                NewTaskButton(text: "12345", isCategory: true)
            }
            TaskView(taskTitle: "Grocery Shopping", category: "Home", complete: "123", priorityColor: Color("HighPriority"), task: Task())
            TaskTracker()
            TaskViewOpen(task: "Grocery Shopping", category: "Home", remaining: 204, completed: 4)
            TaskEditButton(text: "Edit Task")
        }
    }
}


struct LabelViews_Previews: PreviewProvider {
    static var previews: some View {
        LabelViews()
        LabelViews().preferredColorScheme(.dark)
    }
}
