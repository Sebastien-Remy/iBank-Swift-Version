//
//  Transaction-CoreDataHelper.swift
//  iBank
//
//  Created by Sebastien REMY on 10/11/2022.
//

import Foundation

extension Transaction {
    
    enum Status {
        case planned, engaged, checked
    }
    
    var transactionDate: Date {
        get { date ?? Date() }
        set {
            guard managedObjectContext  != nil else { return }
            date = newValue
        }
    }
    
    var transactionTitle: String {
        get { title ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            title = newValue
        }
    }
    

}
