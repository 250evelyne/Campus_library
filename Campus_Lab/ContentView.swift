//
//  ContentView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        TabView {
            BooksView()
                .tabItem { Label("Books", systemImage: "book") }

            MembersView()
                .tabItem { Label("Members", systemImage: "person.2") }

            LoansView()
                .tabItem { Label("Loans", systemImage: "book.circle") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
    }
}
