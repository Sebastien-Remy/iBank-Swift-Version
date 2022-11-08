//
//  Account-CoreDataHelpers.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import Foundation
import CoreData

extension Account {
    
    convenience init(context: NSManagedObjectContext,
                     name: String,
                     originalBalance: Double) {
        self.init(context: context)
        self.name = name
        self.originalBalance = originalBalance
    }
    
    var accountName: String {
        get { name ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            name = newValue
        }
    }
}
