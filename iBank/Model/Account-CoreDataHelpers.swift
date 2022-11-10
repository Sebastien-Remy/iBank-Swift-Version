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
    
    var accountTransactions: [Transaction] {
        let set = transactions as? Set<Transaction> ?? []
        return set.sorted {
            $0.transactionDate < $1.transactionDate
        }
    }
}
