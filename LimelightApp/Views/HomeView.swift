//
//  HomeView.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-03-31.
//

import SwiftUI

struct HomeView: View {
    var activeDate: TaskDate
    
    var body: some View {
        
        let taskPriorityHigh =
            activeDate.taskArrayPriority(priority: .high)
        let taskPriorityMedium =
            activeDate.taskArrayPriority(priority: .medium)
        let taskPriorityLow =
            activeDate.taskArrayPriority(priority: .low)
        
            VStack(alignment: .leading) {
                DashboardPriorityView(priority: "High Priority", priorityAmount: "1", listed: taskPriorityHigh.count, remaining: activeDate.taskArrayIsComplete(onArray: taskPriorityHigh, completed: false).count, completed: activeDate.taskArrayIsComplete(onArray: taskPriorityHigh, completed: true).count, priorityColor: Color("HighPriority"))
                    //.padding(.top, 10)
                    .padding(.horizontal)
                DashboardPriorityView(priority: "Medium Priority", priorityAmount: "3", listed: taskPriorityMedium.count, remaining: activeDate.taskArrayIsComplete(onArray: taskPriorityMedium, completed: false).count, completed: activeDate.taskArrayIsComplete(onArray: taskPriorityMedium, completed: true).count, priorityColor: Color("MediumPriority"))
                    .padding(.top)
                    .padding(.horizontal)
                DashboardPriorityView(priority: "Low Priority", priorityAmount: "5", listed: taskPriorityLow.count, remaining: activeDate.taskArrayIsComplete(onArray: taskPriorityLow, completed: false).count, completed: activeDate.taskArrayIsComplete(onArray: taskPriorityLow, completed: true).count, priorityColor: Color("LowPriority"))
                    .padding(.top)
                    .padding(.horizontal)
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(activeDate: TaskDate(isActive: true))
        HomeView(activeDate: TaskDate(isActive: true)).preferredColorScheme(.dark)
    }
}
