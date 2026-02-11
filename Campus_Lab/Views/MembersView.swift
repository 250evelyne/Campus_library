//
//  MembersView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI
import CoreData

struct MembersView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var holder: LibraryHolder
    
    var body: some View {
        NavigationStack {
            VStack {
                if holder.members.isEmpty {
                    EmptyStateView(title: "No members", systemImage: "person.2")
                } else {
                    List {
                        ForEach(holder.members) { member in
                            NavigationLink {
                                MemberDetailView(member: member)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(member.name ?? "Member")
                                        .font(.headline)
                                    Text(member.email ?? "No email")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Members")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddMemberView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                holder.refreshMembers(context)
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.map { holder.members[$0] }.forEach { holder.deleteMember($0, context) }
    }
}

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MembersView()
                .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
        }
    }
}
