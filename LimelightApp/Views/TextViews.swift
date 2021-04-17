//
//  TextViews.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-03-30.
//

import SwiftUI

struct TextViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TitleText: View {
    var name: String
    var listed: Int
    var completed: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Hello \(name),")
                .foregroundColor(Color("TitleTextHeader"))
                .font(.title)
                .fontWeight(.bold)
                .kerning(0.56)
            Text("Today you have listed \(listed) tasks and completed \(completed).")
                .font(.callout)
                .fontWeight(.semibold)
        }
    }
}

struct HomeTitleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(Color("TitleTextHeader"))
            .font(.title)
            .fontWeight(.bold)
            .kerning(0.56)
    }
}

struct DateText: View {
    var date: String
    
    var body: some View {
        Text(date.uppercased())
            .foregroundColor(Color("DateTitleText"))
            .font(.footnote)
            .fontWeight(.bold)
            .kerning(0.52)
    }
}

struct HomeText: View {
    var text: String
    
    var body: some View {
        Text(text.uppercased())
            .foregroundColor(Color("TaskSubtext"))
            .font(.footnote)
            .fontWeight(.bold)
            .kerning(0.52)
    }
}

struct TaskHeader: View {
    var text: String
    
    var body: some View {
        Text(text.capitalized)
            .foregroundColor(Color("PriorityTextHeader"))
            .font(.title)
            .fontWeight(.bold)
            .kerning(0.56)
    }
}

struct TaskTitle: View {
    var text: String
    
    var body: some View {
        Text(text.capitalized)
            .foregroundColor(Color("PriorityTextHeader"))
            .font(.headline)
            .fontWeight(.semibold)
    }
}

struct TrackingText: View {
    var text: String
    
    var body: some View {
        Text(text.capitalized)
            .foregroundColor(Color("RemainingText"))
            .font(.callout)
            .fontWeight(.semibold)
            .kerning(0.64)
    }
}

struct TrackingTitleText: View {
    var text: String
    
    var body: some View {
        Text(text.capitalized)
            .foregroundColor(Color("RemainingText"))
            .font(.callout)
            .fontWeight(.regular)
    }
}

struct ListHeader: View {
    var text: String
    
    var body: some View {
        Text(text.capitalized)
            .foregroundColor(Color("TitleTextHeader"))
            .font(.title3)
            .fontWeight(.semibold)
    }
}

struct TextFieldText: View {
    var text: String
    
    var body: some View {
        Text(text.lowercased())
            .font(.callout)
            .foregroundColor(Color("RemainingText"))
            .italic()
    }
}

struct DescriptionText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.callout)
            .foregroundColor(Color("RemainingText"))
    }
}

struct TextViews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TitleText(name: "Tiarra", listed: 3, completed: 4)
                .padding()
            DateText(date: "Tuesday, May 26")
            TaskHeader(text: "Create New Task")
            TaskTitle(text: "Create New Task")
            HStack {
                TrackingText(text: "0/5")
                TrackingTitleText(text: "Tasks Completed")
            }
            ListHeader(text: "High Priority")
            DescriptionText(text: "Pick up from Whole Foods: bananas, oat milk, avocados, and ingredients for pasta; Pick up from Walmart: kitchen towels")
        }
    }
}
