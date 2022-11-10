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
    
    var transactionName: String {
        get { name ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            name = newValue
        }
    }
    
    var transactionDetails: [TransactionDetail] {
        let set = details as? Set<TransactionDetail> ?? []
        return set.sorted {
            $0.amount < $1.amount
        }
    }
}
