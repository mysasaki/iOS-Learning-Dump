//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Mylla on 22/03/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.data.type) {
                        ForEach(OrderData.types.indices, id: \.self) {
                            Text(OrderData.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.data.quantity)", value: $order.data.quantity)
                }
                
                Section {
                    Toggle("Special request?", isOn: $order.data.specialRequestEnabled.animation())
                    
                    if order.data.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.data.extraFrosting)
                        
                        Toggle("Add extra sprinkles", isOn: $order.data.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink("Delivery details") {
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
