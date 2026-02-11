//
//  MemberDetailView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI
import CoreData

struct MemberDetailView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: LibraryHolder
    
    @ObservedObject var member: Member
    
    var body: some View {
        let loans = (member.loans as? Set<Loan>)?.sorted {
            ($0.borrowedAt ?? Date()) > ($1.borrowedAt ?? Date())
        } ?? []
        
        let activeLoans = loans.filter { $0.returnedAt == nil }
        let pastLoans = loans.filter { $0.returnedAt != nil }
        
        List {
            Section("Info") {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(member.name ?? "Member")
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(member.email ?? "No email")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Joined")
                    Spacer()
                    Text(member.joinedAt ?? Date(), style: .date)
                        .foregroundStyle(.secondary)
                }
            }
            
            Section("Active Loans") {
                if activeLoans.isEmpty {
                    Text("No active loans")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(activeLoans) { loan in
                        LoanRow(loan: loan)
                    }
                }
            }
            
            Section("Past Loans") {
                if pastLoans.isEmpty {
                    Text("No past loans")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(pastLoans) { loan in
                        LoanRow(loan: loan)
                    }
                }
            }
            
            Section {
                NavigationLink {
                    BorrowBookView(member: member)
                } label: {
                    Label("Borrow a Book", systemImage: "book.circle")
                }
            }
        }
        .navigationTitle(member.name ?? "Member")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    EditMemberView(member: member)
                } label: {
                    Text("Edit")
                }
            }
        }
        .onAppear {
            holder.refreshLoans(context)
        }
    }
}

struct LoanRow: View {
    let loan: Loan
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(loan.book?.title ?? "Book")
                .font(.headline)
            
            HStack {
                Text("Due: \(loan.dueAt ?? Date(), style: .date)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if loan.returnedAt == nil && (loan.dueAt ?? Date()).isOverdue {
                    Text("• OVERDUE")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .bold()
                }
            }
        }
    }
}

struct MemberDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MemberDetailView(member: Member())
                .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
        }
    }
}
