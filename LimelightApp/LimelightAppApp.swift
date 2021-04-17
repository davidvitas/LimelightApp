//
//  LimelightAppApp.swift
//  LimelightApp
//
//  Created by David Vitas on 2021-03-30.
//

import SwiftUI

@main
struct LimelightAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(taskDate: TaskDate(isActive: true))
        }
    }
}
