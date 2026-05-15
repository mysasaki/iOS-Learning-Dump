//
//  EditUserView.swift
//  SwiftDataProject
//
//  Created by Mylla Sasaki on 14/05/26.
//

import SwiftUI
import SwiftData

struct EditUserView: View {
    @Bindable var user: User
    
    var body: some View {
        Form {
            TextField("Name", text: $user.name)
            TextField("City", text: $user.city)
            DatePicker("Join date", selection: $user.joinDate)
        }
        .navigationTitle("Edit user")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: User.self, configurations: config)
        let user = User(name: "Jane Doe", city: "Los Angeles", joinDate: .now)
        
        return EditUserView(user: user)
    }
    catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
