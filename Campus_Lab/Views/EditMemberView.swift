//
//  EditMemberView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-11.
//

import SwiftUI
import CoreData

struct EditMemberView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: LibraryHolder
    
    @ObservedObject var member: Member
    
    @State private var name = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            Section("Member Details") {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            }
            
            Section("Member Since") {
                HStack {
                    Text("Joined")
                    Spacer()
                    Text(member.joinedAt ?? Date(), style: .date)
                        .foregroundStyle(.secondary)
                }
            }
            
            Section {
                Button("Save") {
                    holder.updateMember(
                        member: member,
                        name: name,
                        email: email,
                        context
                    )
                    dismiss()
                }
                .disabled(!canSave)
                
                Button("Delete Member", role: .destructive) {
                    holder.deleteMember(member, context)
                    dismiss()
                }
            }
        }
        .navigationTitle("Edit Member")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            name = member.name ?? ""
            email = member.email ?? ""
        }
    }
    
    private var canSave: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return !trimmedName.isEmpty && !trimmedEmail.isEmpty
    }
}

struct EditMemberView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditMemberView(member: Member())
                .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
        }
    }
}
