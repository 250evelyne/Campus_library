//
//  Campus_LabApp.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//


import SwiftUI
import CoreData

@main
struct Campus_LabApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let ctx = persistenceController.container.viewContext
            ContentView()
                .environment(\.managedObjectContext, ctx)
                .environmentObject(LibraryHolder(ctx))
        }
    }
}
