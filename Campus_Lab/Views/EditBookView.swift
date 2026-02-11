//
//  EditBookView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI
import CoreData

struct EditBookView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: LibraryHolder
    
    @ObservedObject var book: Book
    
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
            
            Section("Status") {
                HStack {
                    Text("Availability")
                    Spacer()
                    Text(book.isAvailable ? "Available" : "Borrowed")
                        .foregroundStyle(book.isAvailable ? .green : .red)
                }
            }
            
            Section {
                Button("Save") {
                    holder.updateBook(
                        book: book,
                        title: title,
                        author: author,
                        isbn: isbn,
                        category: selectedCategory,
                        context
                    )
                    dismiss()
                }
                
                Button("Delete Book", role: .destructive) {
                    holder.deleteBook(book, context)
                    dismiss()
                }
            }
        }
        .navigationTitle("Edit Book")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            holder.refreshCategories(context)
            
            title = book.title ?? ""
            author = book.author ?? ""
            isbn = book.isbn ?? ""
            selectedCategory = book.category
        }
    }
}

struct EditBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditBookView(book: Book())
                .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
        }
    }
}
