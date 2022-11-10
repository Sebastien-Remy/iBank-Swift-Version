//
//  DataController.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import CoreData
import SwiftUI

enum IBankEntity {
    case account, category, third, project
}

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "iBank") // must match the name in model!
    var saveTask: Task<Void, Error>?
    
    @Published var selectedView: IBankEntity = .account
    @Published var selectedAccount: Account?
    @Published var selectedCategory: Category?
    @Published var selectedThird: Third?
    @Published var selectedProject: Project?
    @Published var selectedTransaction: Transaction?
    
    init() {
        container.loadPersistentStores { descritption, error in
            if let error = error {
                // THIS IS ONLY FOR DEBUG
                // IN PRODUCTION HANDLE ERROR IN ANOTHER WAY AND DO NOT DELETE FILE !!
                print("Core Data failed to load: \(error.localizedDescription)")
                print("Core Data file will be deleted")
                let url:URL = self.container.persistentStoreDescriptions.first!.url!
                try! self.container.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
                
            }
        }
    }
    
    func save() {
        guard container.viewContext.hasChanges else { return }
        try? container.viewContext.save()
    }
    
    func enqueueSave(_ change: Any) {
        saveTask?.cancel()
        
        saveTask = Task {
            @MainActor in
            try await Task.sleep(for: .seconds(5))
            save()
        }
    }
}
