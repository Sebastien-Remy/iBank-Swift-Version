//
//  Transaction-CoreDataHelper.swift
//  iBank
//
//  Created by Sebastien REMY on 10/11/2022.
//

import Foundation
import CoreData

extension TransactionMain {
    
    convenience init(context: NSManagedObjectContext,
                     date: Date,
                     dateChecked: Date,
                     title: String,
                     subTitle: String,
                     statusInt: Int) {
        self.init(context: context)
        self.date = date
        self.dateChecked = dateChecked
        self.title = title
        self.subTitle = subTitle
        self.status = Int16(statusInt)
    }
    
    var transactionDate: Date {
        get { date ?? Date() }
        set {
            guard managedObjectContext  != nil else { return }
            date = newValue
        }
    }
    
    var transactionDateChecked: Date {
        get { dateChecked ?? Date() }
        set {
            guard managedObjectContext  != nil else { return }
            dateChecked = newValue
        }
    }
    
    var transactionTitle: String {
        get { title ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            title = newValue
        }
    }
    
    var transactionsubTitle: String {
        get { subTitle ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            subTitle = newValue
        }
    }
    
    var transactionNotes: String {
        get { notes ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            notes = newValue
        }
    }
    
    var transactionStatus: TransactionStatus {
        get {
            return TransactionStatus(rawValue: Int(status)) ?? TransactionStatus.planned
        }
        set {
            guard managedObjectContext  != nil else { return }
            status = Int16(newValue.rawValue)
        }
    }
    
    var transactionBalance: Double {
        get {
            let transactionDetailsArray = transactionDetails as? Set<TransactionDetail> ?? []
            return transactionDetailsArray.reduce(.zero, {$0 + $1.amount})
        }
    }
    
    var transactionDebit: Double {
        get {
            return transactionBalance <= 0 ? transactionBalance : 0.0
        }
    }
    
    var transactionCredit: Double {
        return transactionBalance >= 0 ? transactionBalance : 0.0
    }

}
