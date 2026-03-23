//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Mylla on 22/03/26.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total cost is \(order.data.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order", action: {
                    Task {
                        await placeOrder()
                    }
                })
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you", isPresented: $showingConfirmation, actions: {
            Button("OK") {}
        },
               message: {
            Text(confirmationMessage)
        })
    }
    
    func placeOrder() async {
        // Encode to JSON
        
        guard let encoded = try? JSONEncoder().encode(order.data) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (_, _) = try await URLSession.shared.upload(for: request, from: encoded)

            confirmationMessage = "Your order for \(order.data.quantity) x \(OrderData.types[order.data.type].lowercased()) cupcakes is on the way!"
            showingConfirmation = true
             
//            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
//
//            print(String(data: data, encoding: .utf8)!)
//
//
//            let decoded = try JSONDecoder().decode(OrderData.self, from: data)
//            confirmationMessage = "Your order for \(decoded.quantity) X \(OrderData.types[decoded.type].lowercased()) cupcakes is on the way!"
        }
        catch {
            print("Checkout failed. \(error.localizedDescription)")
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
