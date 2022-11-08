//
//  DataController.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import CoreData

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "iBank") // must match the name in model!
    var saveTask: Task<Void, Error>?
    
    @Published var selectedAccount: Account?
    @Published var selectedCategory: Category?
    
    
    init() {
        container.loadPersistentStores { descritption, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
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
