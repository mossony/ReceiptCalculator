//
//  ContentView.swift
//  ReceiptCalculator
//
//  Created by Boyang Wan on 2023-10-07.
//

import SwiftUI
import CoreData
struct Entry {
    var id = UUID()
    var itemPrice: String = ""
    var ratioStr: String = ""
    var tax: Bool = false
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {
    @State private var numShoppers: String = ""
    @State private var shopperNames: [String] = []
    @State private var isNumConfirmed: Bool = false
    @State private var itemPrices: [Double] = []
    @State private var shopperRatios: [[Double]] = []
    @State private var results: [String] = []
    @State private var navigationTarget: String? = nil
    @State private var enterPrice: Bool = false
    @State private var entryCount: Int = 1
    @State private var entries: [Entry] = [Entry()]
    @State private var showResult: Bool = false
    @GestureState private var dragOffset = CGSize.zero
    // ... other state properties
    
    func calculateRatio(ratioStr: String) -> [Double] {
        let ratios = ratioStr.split(separator: "/").compactMap { Double($0) }
        let totalRatio = ratios.reduce(0, +)
        return ratios.map { $0 / totalRatio }
    }
    
    
    func calculateOwes() {
        var total_owe: [Double] = Array(repeating: 0.0, count: Int(numShoppers) ?? 2)
        print(entries)
        results = []
        for i in 0..<entries.count {
            for j in 0..<(Int(numShoppers) ?? 2){
                let ratio: [Double] = calculateRatio(ratioStr: entries[i].ratioStr)
                let slashes = entries[i].ratioStr.components(separatedBy: "/").count - 1
                if slashes == (Int(numShoppers)! - 1){
                    if entries[i].itemPrice != ""{
                        if entries[i].tax{
                            total_owe[j] += (Double(entries[i].itemPrice) ?? 0) * ratio[j] * 1.13
                        }
                        else{
                            total_owe[j] += (Double(entries[i].itemPrice) ?? 0) * ratio[j]
                        }
                    }
                }
            }
        }
        
        for k in 0..<(Int(numShoppers) ?? 2){
            results.append(String(format: shopperNames[k] + " owes %.2f", total_owe[k]))
        }
        print(total_owe)
        showResult = true
    }

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    TextField("How many shoppers?", text: $numShoppers)
                        .padding()
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Confirm") {
                        if let count = Int(self.numShoppers), count > 0 {
                            self.shopperNames = Array(repeating: "", count: count)
                            self.isNumConfirmed = true
                        }
                    }
                }
                
                
                
                if self.isNumConfirmed {
                    ForEach(0..<shopperNames.count, id: \.self) { index in
                        TextField("Enter the name of shopper \(index + 1)", text: $shopperNames[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Button("Submit") {
                    // Handle your logic here...
                    enterPrice = true
                }
                .padding()
                
                if enterPrice{
                    ForEach(entries.indices, id: \.self) { index in
                        HStack {
                            TextField("Price", text: $entries[index].itemPrice, onCommit: {
                            })
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading)
                            
                            TextField("Ratio", text: $entries[index].ratioStr, onCommit: {
                                entries.append(Entry())
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing)
                            Toggle(isOn: $entries[index].tax) {
                                Text("tax").padding(.trailing, -5)
                            }
                            
                        }
                        .padding(.top, 10)
                    }
                    Button("Calculate") {
                        calculateOwes()
                    }.padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                }
                
                if showResult{
                    ForEach(self.results, id: \.self) { item in
                        Text(item)
                            .font(.title)
                            .padding()
                    }
                }
                
                
            }
        }.padding()
        .gesture(DragGesture().onChanged({ _ in
            UIApplication.shared.endEditing()
        }))
        
        
        
    }
}

struct ProductEntryView: View {
    @State private var productPrice: String = ""
    @State private var ratio: String = ""

    var body: some View {
        VStack {
            TextField("Enter the price of the product", text: $productPrice)
                .keyboardType(.decimalPad)
            TextField("Enter the ratio (e.g. 5/5)", text: $ratio)
                .keyboardType(.numbersAndPunctuation)
            Button("Submit") {
                // Handle the logic after getting the product price and ratio
            }
        }
        .padding()
    }
}
