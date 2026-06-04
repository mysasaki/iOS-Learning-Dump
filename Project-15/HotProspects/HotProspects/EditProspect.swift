//
//  EditProspect.swift
//  HotProspects
//
//  Created by Mylla Sasaki on 02/06/26.
//

import SwiftUI
import SwiftData

struct EditProspect: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var prospect: Prospect
    
    var body: some View {
        Form {
            Section("Prospect information") {
                TextField("Name", text: $prospect.name)
                    .textContentType(.name)
                TextField("Email Address", text: $prospect.emailAddress)
                    .textContentType(.emailAddress)
                
                Button("Save") {
                    dismiss()
                }
            }
        }
        .navigationTitle("Edit prospect")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let prospect = Prospect(name: "Johny Walker", emailAddress: "johnywalker@example.com", isContacted: false)
    
    EditProspect(prospect: prospect)
        .modelContainer(for: Prospect.self)
}
