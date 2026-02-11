//
//  LoansView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI
import CoreData

struct LoansView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: LibraryHolder
    
    var body: some View {
        NavigationStack {
            VStack {
                if holder.loans.isEmpty {
                    EmptyStateView(title: "No loans", systemImage: "book.circle")
                } else {
                    List {
                        ForEach(holder.loans) { loan in
                            LoanDetailRow(loan: loan)
                        }
                    }
                }
            }
            .navigationTitle("Loans")
            .onAppear {
                holder.refreshLoans(context)
            }
        }
    }
}

struct LoanDetailRow: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: LibraryHolder
    
    @ObservedObject var loan: Loan
    
    var body: some View {
        let isActive = loan.returnedAt == nil
        let isOverdue = isActive && (loan.dueAt ?? Date()).isOverdue
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(loan.book?.title ?? "Book")
                    .font(.headline)
                Spacer()
                
                if isActive {
                    Text("Active")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(isOverdue ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                        .foregroundStyle(isOverdue ? .red : .green)
                        .clipShape(Capsule())
                } else {
                    Text("Returned")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .foregroundStyle(.secondary)
                        .clipShape(Capsule())
                }
            }
            
            Text("Member: \(loan.member?.name ?? "Unknown")")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                Text("Borrowed: \(loan.borrowedAt ?? Date(), style: .date)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("Due: \(loan.dueAt ?? Date(), style: .date)")
                    .font(.caption)
                    .foregroundStyle(isOverdue ? .red : .secondary)
                    .bold(isOverdue)
            }
            
            if let returnDate = loan.returnedAt {
                Text("Returned: \(returnDate, style: .date)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if isActive {
                Button {
                    holder.returnLoan(loan, context)
                } label: {
                    Label("Return Book", systemImage: "checkmark.circle")
                        .font(.subheadline)
                }
                .buttonStyle(.borderedProminent)
                .tint(isOverdue ? .red : .blue)
            }
        }
        .padding(.vertical, 4)
    }
}

struct LoansView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoansView()
                .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
        }
    }
}
