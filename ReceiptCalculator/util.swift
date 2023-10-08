//
//  util.swift
//  ReceiptCalculator
//
//  Created by Boyang Wan on 2023-10-07.
//

import Foundation

func getShopperNames(numShoppers: Int) -> [String] {
    var shopperNames: [String] = []
    for i in 0..<numShoppers {
        print("Enter the name of shopper \(i + 1): ")
        if let name = readLine() {
            shopperNames.append(name)
        }
    }
    return shopperNames
}

func calculateRatio(ratioStr: String) -> [Double] {
    let ratios = ratioStr.split(separator: "/").compactMap { Double($0) }
    let totalRatio = ratios.reduce(0, +)
    return ratios.map { $0 / totalRatio }
}

func main() {
    print("Enter the total number of shoppers: ")
    if let numShoppersStr = readLine(), let numShoppers = Int(numShoppersStr) {
        let shopperNames = getShopperNames(numShoppers: numShoppers)
        
        var itemPrices: [Double] = []
        var i = 0
        var priceRaw = ""
        var shopperRatios = Array(repeating: [Double](), count: numShoppers)
        
        repeat {
            print("Enter the price of item \(i + 1): ")
            priceRaw = readLine() ?? ""
            
            if !priceRaw.isEmpty {
                var price: Double = 0.0
                if priceRaw.hasSuffix("t") {
                    if let value = Double(priceRaw.dropLast()) {
                        price = value * 1.13
                    }
                } else {
                    price = Double(priceRaw) ?? 0.0
                }

                itemPrices.append(price)
                print("Enter the ratio for item \(i + 1) for \(shopperNames.joined(separator: "/")) (Default 5/5): ")
                var ratioStr = readLine() ?? ""
                
                if ratioStr.isEmpty {
                    ratioStr = "5/5"
                }
                let ratios = calculateRatio(ratioStr: ratioStr)
                
                for j in 0..<numShoppers {
                    shopperRatios[j].append(ratios[j])
                }
                i += 1
            }
            
        } while !priceRaw.isEmpty
        
        for i in 0..<numShoppers {
            let totalCost = zip(itemPrices, shopperRatios[i]).map { $0.0 * $0.1 }.reduce(0, +)
            print("\(shopperNames[i]) owes $\(String(format: "%.2f", totalCost))")
        }
    }
}


