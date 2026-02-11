//
//  BorrowBookView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI
import CoreData

struct BorrowBookView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: LibraryHolder
    
    let member: Member
    
    @State private var selectedBook: Book?
    @State private var dueDays: Int = 14
    
    var body: some View {
        let availableBooks = holder.books.filter { $0.isAvailable }
        
        Form {
            Section("Select Book") {
                if availableBooks.isEmpty {
                    Text("No available books")
                        .foregroundStyle(.secondary)
                } else {
                    Picker("Book", selection: $selectedBook) {
                        Text("Select a book").tag(Book?.none)
                        ForEach(availableBooks) { book in
                            Text(book.title ?? "Book").tag(Book?.some(book))
                        }
                    }
                }
            }
            
            Section("Due Date") {
                Stepper("Days: \(dueDays)", value: $dueDays, in: 7...30)
            }
            
            if let book = selectedBook {
                Section("Book Details") {
                    HStack {
                        Text("Title")
                        Spacer()
                        Text(book.title ?? "Book")
                    }
                    HStack {
                        Text("Author")
                        Spacer()
                        Text(book.author ?? "Unknown")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Button("Borrow") {
                if let book = selectedBook {
                    holder.borrowBook(member: member, book: book, dueDays: dueDays, context)
                    dismiss()
                }
            }
            .disabled(selectedBook == nil)
        }
        .navigationTitle("Borrow Book")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            holder.refreshBooks(context)
            selectedBook = availableBooks.first
        }
    }
}

struct BorrowBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BorrowBookView(member: Member())
                .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
        }
    }
}
