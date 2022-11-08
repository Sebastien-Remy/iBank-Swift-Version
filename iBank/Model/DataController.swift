//
//  DataController.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import CoreData
enum SelectionItem {
    case account, category, third, project
}

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "iBank") // must match the name in model!
    var saveTask: Task<Void, Error>?
    
    @Published var currentSelection: SelectionItem?
    @Published var selectedAccount: Account? {
        didSet {
            if currentSelection != .account && selectedAccount != nil {
                    selectedCategory = nil
                    selectedThird = nil
                    selectedProject = nil
                    currentSelection = .account
                    
                }
        }
    }
    @Published var selectedCategory: Category? {
        didSet {
            if currentSelection != .category && selectedCategory != nil {
                selectedAccount = nil
                selectedThird = nil
                selectedProject = nil
                currentSelection = .category
            }
        }
    }
    @Published var selectedThird: Third? {
        didSet {
            if currentSelection != .third && selectedThird != nil {
                selectedAccount = nil
                selectedCategory = nil
                selectedProject = nil
                currentSelection = .third
            }
        }
    }
    
    @Published var selectedProject: Project? {
        didSet {
            if currentSelection != .project && selectedProject != nil {
                selectedAccount = nil
                selectedCategory = nil
                selectedThird = nil
                currentSelection = .project
            }
        }
    }
    
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
