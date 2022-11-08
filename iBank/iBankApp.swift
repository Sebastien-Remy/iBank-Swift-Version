//
//  iBankApp.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

@main
struct iBankApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
