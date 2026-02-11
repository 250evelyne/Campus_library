//
//  LibraryHolder.swift
//  Campus_Lab
//
//  Created by mac on 2026-02-10.
//



import SwiftUI
import CoreData
import Combine

final class LibraryHolder: ObservableObject {
    
    // ui state
    @Published var selectedCategory: Category? = nil
    @Published var searchText: String = ""
    
    //published data
    @Published var categories: [Category] = []
    @Published var books: [Book] = []
    @Published var members: [Member] = []
    @Published var loans: [Loan] = []
    
    init(_ context: NSManagedObjectContext) {
        seedIfNeeded(context)
        refreshAll(context)
    }
   
    func refreshAll(_ context: NSManagedObjectContext) {
        refreshCategories(context)
        refreshBooks(context)
        refreshMembers(context)
        refreshLoans(context)
    }
    
    func refreshCategories(_ context: NSManagedObjectContext) {
        categories = fetchCategories(context)
    }
    
    func refreshBooks(_ context: NSManagedObjectContext) {
        books = fetchBooks(context)
    }
    
    func refreshMembers(_ context: NSManagedObjectContext) {
        members = fetchMembers(context)
    }
    
    func refreshLoans(_ context: NSManagedObjectContext) {
        loans = fetchLoans(context)
    }
    
 //fecth mds
    func fetchCategories(_ context: NSManagedObjectContext) -> [Category] {
        do { return try context.fetch(categoriesFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchBooks(_ context: NSManagedObjectContext) -> [Book] {
        do { return try context.fetch(booksFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchMembers(_ context: NSManagedObjectContext) -> [Member] {
        do { return try context.fetch(membersFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    func fetchLoans(_ context: NSManagedObjectContext) -> [Loan] {
        do { return try context.fetch(loansFetch()) }
        catch { fatalError("Unresolved error \(error)") }
    }
    
    // fetch rqs
    func categoriesFetch() -> NSFetchRequest<Category> {
        let request = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }

    func booksFetch() -> NSFetchRequest<Book> {
        let request = Book.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "addedAt", ascending: false),
            NSSortDescriptor(key: "title", ascending: true)
        ]
        request.predicate = booksPredicate()
        return request
    }

    func membersFetch() -> NSFetchRequest<Member> {
        let request = Member.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }

    func loansFetch() -> NSFetchRequest<Loan> {
        let request = Loan.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "borrowedAt", ascending: false)]
        return request
    }
    // seacrh and filter
    private func booksPredicate() -> NSPredicate? {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var parts: [NSPredicate] = []
        
        if let category = selectedCategory {
            parts.append(NSPredicate(format: "category == %@", category))
        }
        
        if !trimmed.isEmpty {
            parts.append(NSPredicate(format: "(title CONTAINS[cd] %@) OR (author CONTAINS[cd] %@)", trimmed, trimmed))
        }
        
        if parts.isEmpty { return nil }
        if parts.count == 1 { return parts[0] }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: parts)
    }
    
// control filter
    func setCategory(_ category: Category?, _ context: NSManagedObjectContext) {
        selectedCategory = category
        refreshBooks(context)
    }
    
    func setSearch(_ text: String, _ context: NSManagedObjectContext) {
        searchText = text
        refreshBooks(context)
    }
    
    // crud category
    func createCategory(name: String, _ context: NSManagedObjectContext) {
        let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !n.isEmpty else { return }
        
        let c = Category(context: context)
        c.id = UUID()
        c.name = n
        
        saveContext(context)
    }
    
    func deleteCategory(_ category: Category, _ context: NSManagedObjectContext) {
        if selectedCategory == category {
            selectedCategory = nil
        }
        context.delete(category)
        saveContext(context)
    }
    
    
    func createBook(
        title: String,
        author: String,
        isbn: String,
        category: Category?,
        _ context: NSManagedObjectContext
    ) {
        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return }
        
        let b = Book(context: context)
        b.id = UUID()
        b.title = t
        b.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
        b.isbn = isbn.trimmingCharacters(in: .whitespacesAndNewlines)
        b.addedAt = Date()
        b.isAvailable = true
        b.category = category
        
        saveContext(context)
    }
    
    func updateBook(
        book: Book,
        title: String,
        author: String,
        isbn: String,
        category: Category?,
        _ context: NSManagedObjectContext
    ) {
        book.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        book.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
        book.isbn = isbn.trimmingCharacters(in: .whitespacesAndNewlines)
        book.category = category
        
        saveContext(context)
    }
    
    func deleteBook(_ book: Book, _ context: NSManagedObjectContext) {
        context.delete(book)
        saveContext(context)
    }
    
    func createMember(
        name: String,
        email: String,
        _ context: NSManagedObjectContext
    ) {
        let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !n.isEmpty else { return }
        
        let m = Member(context: context)
        m.id = UUID()
        m.name = n
        m.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        m.joinedAt = Date()
        
        saveContext(context)
    }
    
    func updateMember(
        member: Member,
        name: String,
        email: String,
        _ context: NSManagedObjectContext
    ) {
        member.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        member.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        saveContext(context)
    }
    
    func deleteMember(_ member: Member, _ context: NSManagedObjectContext) {
        // cant delete meber if their loan is stil on, will first make it available
        if let loans = member.loans as? Set<Loan> {
            for loan in loans {
                if loan.returnedAt == nil {
                    loan.book?.isAvailable = true
                }
            }
        }
        
        context.delete(member)
        saveContext(context)
    }
   
   
    func borrowBook(member: Member, book: Book, dueDays: Int, _ context: NSManagedObjectContext) {
        guard book.isAvailable else { return }
        
        let loan = Loan(context: context)
        loan.id = UUID()
        loan.borrowedAt = Date()
        loan.dueAt = Date().addingTimeInterval(TimeInterval(dueDays * 86400))
        loan.member = member
        loan.book = book
        
        book.isAvailable = false
        
        saveContext(context)
    }

    func returnLoan(_ loan: Loan, _ context: NSManagedObjectContext) {
        loan.returnedAt = Date()
        loan.book?.isAvailable = true
        
        saveContext(context)
    }
    
   
    private func seedIfNeeded(_ context: NSManagedObjectContext) {
        let req = Category.fetchRequest()
        req.fetchLimit = 1
        let count = (try? context.count(for: req)) ?? 0
        guard count == 0 else { return }
        

        let fiction = Category(context: context)
        fiction.id = UUID()
        fiction.name = "Fiction"
        
        let nonFiction = Category(context: context)
        nonFiction.id = UUID()
        nonFiction.name = "Non-Fiction"
        
  
        let book1 = Book(context: context)
        book1.id = UUID()
        book1.title = "Verity"
        book1.author = "F. Scott "
        book1.isbn = "514-0743273565"
        book1.addedAt = Date()
        book1.isAvailable = true
        book1.category = fiction
        
        let book2 = Book(context: context)
        book2.id = UUID()
        book2.title = "Twisted Lies"
        book2.author = "Susan Dévil"
        book2.isbn = "514-0062316097"
        book2.addedAt = Date()
        book2.isAvailable = true
        book2.category = nonFiction
        
        let book3 = Book(context: context)
        book2.id = UUID()
        book2.title = "Reminders of Him"
        book2.author = "Colleen Hoover"
        book2.isbn = "416-006231128901"
        book2.addedAt = Date()
        book2.isAvailable = true
        book2.category = nonFiction
        
      
        let member1 = Member(context: context)
        member1.id = UUID()
        member1.name = "Evelyne"
        member1.email = "eve@gmail.com"
        member1.joinedAt = Date()
        
        saveContext(context)
    }
    
  
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            refreshAll(context)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
