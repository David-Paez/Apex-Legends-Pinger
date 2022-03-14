//
//  Apex_Legends_PingerApp.swift
//  Apex Legends Pinger
//
//  Created by David Paez on 3/13/22.
//

import SwiftUI

@main
struct Apex_Legends_PingerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
