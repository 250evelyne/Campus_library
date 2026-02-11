//
//  BooksView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI
import CoreData

struct BooksView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: LibraryHolder
    
    @State private var searchDraft: String = ""
    
    private let cols = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                
                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    TextField("Search books...", text: $searchDraft)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .padding(12)
                .background(.secondary.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
                .onChange(of: searchDraft) { newValue in
                    holder.setSearch(newValue, context)
                }
                
                // Category bar
                categoryBar
                
                // Grid
                if holder.books.isEmpty {
                    EmptyStateView(title: "No books found", systemImage: "book")
                } else {
                    ScrollView {
                        LazyVGrid(columns: cols, spacing: 12) {
                            ForEach(holder.books) { book in
                                BookCard(book: book)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }
                }
            }
            .navigationTitle("Books")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddBookView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                holder.refreshAll(context)
                searchDraft = holder.searchText
            }
        }
    }
    
    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                
                Button {
                    holder.setCategory(nil, context)
                } label: {
                    Text("All")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            holder.selectedCategory == nil
                            ? Color.primary.opacity(0.12)
                            : Color.clear
                        )
                        .clipShape(Capsule())
                }
                
                ForEach(holder.categories) { c in
                    Button {
                        holder.setCategory(c, context)
                    } label: {
                        Text(c.name ?? "Category")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                holder.selectedCategory == c
                                ? Color.primary.opacity(0.12)
                                : Color.clear
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct BookCard: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: LibraryHolder
    
    let book: Book
    
    var body: some View {
        NavigationLink {
            EditBookView(book: book)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(book.isAvailable ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                        .frame(height: 110)
                    
                    VStack {
                        Image(systemName: book.isAvailable ? "book" : "book.closed")
                            .font(.system(size: 34, weight: .semibold))
                        Text(book.isAvailable ? "Available" : "Borrowed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text(book.title ?? "Book")
                    .font(.headline)
                    .lineLimit(1)
                
                Text(book.author ?? "Unknown")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(12)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(.secondary.opacity(0.15), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BooksView()
                .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
        }
    }
}
