//
//  TransactionListingView.swift
//  iBank
//
//  Created by Sebastien REMY on 10/11/2022.
//

import SwiftUI

struct TransactionListingView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    var transactions: [Transaction]
    
    var body: some View {
        List(transactions, selection: $dataController.selectedTransaction) { transaction in
            HStack {
                Text(transaction.transactionDate, style: .date)
                Text(transaction.transactionTitle)
            }
            .contextMenu {
                if dataController.selectedTransaction != nil {
                    Button("Delete transaction", role: .destructive, action: deleteSelected)
                }
            }
            .tag(transaction)
        }
        .padding([.leading])
     
    }
    
    func deleteSelected() {
        guard let selectedTransaction = dataController.selectedTransaction else { return }
        guard let selectedIndex = transactions.firstIndex(of: selectedTransaction) else { return }
        managedObjectContext.delete(selectedTransaction)
        dataController.save()
        
        if selectedIndex < transactions.count {
            dataController.selectedTransaction = transactions [selectedIndex]
        } else {
            let previousIndex = selectedIndex - 1
            if previousIndex >= 0 {
                dataController.selectedTransaction = transactions [previousIndex]
            } else {
                dataController.selectedTransaction = nil
            }
        }
    }
}

//struct TransactionListingView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionListingView()
//    }
//}
