//
//  Account-CoreDataHelpers.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import Foundation
import CoreData
import SwiftUI
import AppKit

extension Account {
    
    convenience init(context: NSManagedObjectContext,
                     name: String,
                     originalBalance: Double) {
        self.init(context: context)
        self.name = name
        self.originalBalance = originalBalance
        self.colorAsHex = Color.primary.toHexString()
        self.iconName = Constants.Account.iconName
    }
    
    var accountName: String {
        get { name ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            name = newValue
        }
    }
    
    var accountColor: Color {
        get { Color(fromHexString: colorAsHex) ?? Color.primary }
        set {
            guard managedObjectContext  != nil else { return }
            colorAsHex = newValue.toHexString()
        }
    }
    
    var accountIconName: String {
        get {
            let systemName = iconName ?? Constants.Account.iconName
            if NSImage(systemSymbolName: systemName, accessibilityDescription: "") == nil { return Constants.Account.iconName }
            return systemName
             }
        set {
            guard managedObjectContext  != nil else { return }
            iconName = newValue
        }
    }
    
    var accountTransactions: [Transaction] {
        let set = transactions as? Set<Transaction> ?? []
        return set.sorted {
            $0.transactionDate < $1.transactionDate
        }
    }
}
