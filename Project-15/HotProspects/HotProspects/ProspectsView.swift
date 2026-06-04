//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Mylla Sasaki on 01/06/26.
//

import SwiftUI
import SwiftData
import CodeScanner
import UserNotifications
internal import AVFoundation

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @Environment(\.modelContext) var modelContext
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    @Binding var sortOrder: [SortDescriptor<Prospect>]
        
    let filter: FilterType
    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }
    
    var body: some View {
        NavigationStack {
            List(prospects, selection: $selectedProspects) { prospect in
                NavigationLink {
                    EditProspect(prospect: prospect)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundStyle(.secondary)
                        }
                        
                        if filter == .none {
                            Spacer()
                            
                            Image(systemName: prospect.isContacted ? "checkmark" : "xmark")
                        }
                    }
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    
                    if prospect.isContacted {
                        Button("Mark uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    }
                    else {
                        Button("Mark contacted", systemImage: "person.crop.circle.fill.badge.checkmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind me", systemImage: "bell") {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect) // Help SwiftUI understand that each row in our list correspond toa single prospect
            }
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Scan", systemImage: "qrcode.viewfinder") {
                            isShowingScanner = true
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder) {
                                Text("Sort by name")
                                    .tag([
                                        SortDescriptor(\Prospect.name),
                                        SortDescriptor(\Prospect.emailAddress)
                                    ])
                                
                                Text("Sort by email")
                                    .tag([
                                        SortDescriptor(\Prospect.emailAddress),
                                        SortDescriptor(\Prospect.name)
                                    ])
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    if selectedProspects.isEmpty == false {
                        Button("Delete selected", action: delete)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.thinMaterial)
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Walker\npaul@example.com", completion: handleScan)
                }
        }
    }
    
    init(filter: FilterType, sortOrder:Binding<[SortDescriptor<Prospect>]>) {
        self.filter = filter
        self._sortOrder = sortOrder
        
        let showContactedOnly = filter == .contacted
        
        if filter != .none {
            _prospects = Query(filter: #Predicate {
                $0.isContacted == showContactedOnly
            }, sort: sortOrder.wrappedValue)
        }
        else {
            _prospects = Query(sort: sortOrder.wrappedValue)
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count ==  2 else { return }
            
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            }
            else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    }
                    else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .none, sortOrder: .constant([
        SortDescriptor(\Prospect.name),
        SortDescriptor(\Prospect.emailAddress)
    ]))
}
