//
//  ReceiptCalculatorApp.swift
//  ReceiptCalculator
//
//  Created by Boyang Wan on 2023-10-07.
//

import SwiftUI

@main
struct ReceiptCalculatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
