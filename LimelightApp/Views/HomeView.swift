//
//  HomeView.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-03-31.
//

import SwiftUI

struct HomeView: View {
    @State private var showingNewTaskView = false
    
    var body: some View {
            VStack(alignment: .leading) {
                DashboardPriorityView(priority: "High Priority", priorityAmount: "1", listed: 2, remaining: 3, completed: 5, priorityColor: Color("HighPriority"))
                    //.padding(.top, 10)
                    .padding(.horizontal)
                DashboardPriorityView(priority: "Medium Priority", priorityAmount: "3", listed: 4, remaining: 3, completed: 5, priorityColor: Color("MediumPriority"))
                    .padding(.top)
                    .padding(.horizontal)
                DashboardPriorityView(priority: "Low Priority", priorityAmount: "5", listed: 4, remaining: 3, completed: 5, priorityColor: Color("LowPriority"))
                    .padding(.top)
                    .padding(.horizontal)
                Spacer()
//                NavigationLink(
//                    destination: NewTaskView(showingNewTaskView: $showingNewTaskView),
//                    isActive: $showingNewTaskView,
//                    label: {
//                        Text("Navigate")
//                    }).hidden()
//                TaskButton(text: "Create New Task", buttonAction: {showingNewTaskView = true
//                })
//                .padding(.horizontal)
//                Spacer()
            }
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
//            .navigationBarTitle("")
//            .navigationBarHidden(true)
            
        //}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        HomeView().preferredColorScheme(.dark)
    }
}
