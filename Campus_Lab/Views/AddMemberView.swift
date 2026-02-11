//
//  AddMemberView.swift
//  Campus_Lab
//
//  Created by eve on 2026-02-10.
//

import SwiftUI
import CoreData

struct AddMemberView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var holder: LibraryHolder
    
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
            
            Button("Create") {
                holder.createMember(name: name, email: email, context)
                dismiss()
            }
            .disabled(!canCreate)
        }
        .navigationTitle("Add Member")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var canCreate: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct AddMemberView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddMemberView()
                .environmentObject(LibraryHolder(PersistenceController.preview.container.viewContext))
        }
    }
}
