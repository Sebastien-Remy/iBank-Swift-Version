//
//  TransactionDetail-CoreDataHelper.swift
//  iBank
//
//  Created by Sebastien REMY on 06/12/2022.
//

import Foundation

extension TransactionDetail {
    var transactionDetailDate: Date {
        get { detailDate ?? Date() }
        set {
            guard managedObjectContext  != nil else { return }
            detailDate = newValue
        }
    }
}
