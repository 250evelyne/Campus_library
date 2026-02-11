//
//  AddBookView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI
import CoreData

struct AddBookView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: LibraryHolder
    
    @State private var title = ""
    @State private var author = ""
    @State private var isbn = ""
    @State private var selectedCategory: Category?
    
    var body: some View {
        Form {
            Section("Book Details") {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                TextField("ISBN", text: $isbn)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Category") {
                Picker("Category", selection: $selectedCategory) {
                    Text("None").tag(Category?.none)
                    ForEach(holder.categories) { c in
                        Text(c.name ?? "Category").tag(Category?.some(c))
                    }
                }
            }
            
            Button("Create") {
                holder.createBook(
                    title: title,
                    author: author,
                    isbn: isbn,
                    category: selectedCategory,
                    context
                )
                dismiss()
            }
            .disabled(!canCreate)
        }
        .navigationTitle("Add Book")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            holder.refreshCategories(context)
            selectedCategory = holder.categories.first
        }
    }
    
    private var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddBookView()
                .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
        }
    }
}
