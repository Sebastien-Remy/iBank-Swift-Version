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
    
    @State private var showingRendered = false
    
    @State var transactions: [Transaction] = []
    
    var body: some View {
        VStack {
            Table($transactions, selection: $dataController.selectedTransaction)
            {
                TableColumn("Date") { $transaction in
                    Text(transaction.transactionDate, style: .date)
                }
                TableColumn("Title") { $transaction in
                    
                    TextField("Title:", text: $transaction.transactionTitle)
                }
            }    // DEBUG ONLY BUTTON
                Button("Add") {
                    let t = Transaction(context: managedObjectContext)
                    t.transactionDate = Date()
                    t.transactionTitle = "test"
                    
                    
                    try? managedObjectContext.save()
                    transactions.append(t)
                }
            
            List(transactions, selection: $dataController.selectedTransaction) { transaction in
                HStack {
                    Text(transaction.transactionDate, style: .date)
                    Text(transaction.transactionTitle)
                     Text(transaction.account?.accountName ?? "Select Account")
                   
                }
//                .contextMenu {
//                    if dataController.selectedTransaction != nil {
//                        Button("Delete transaction", role: .destructive, action: deleteSelected)
//                    }
//                }
                .tag(transaction)
            }
            Button {
                showingRendered.toggle()
            } label: {
                Label("Add", systemImage: "plus")
                    .labelStyle(.iconOnly)
            }
            .padding([.leading])
            .sheet(isPresented: $showingRendered,
                   content: { TransactionDetailView(moc: managedObjectContext) }
            )
        }
    }
    
//    func deleteSelected() {
//        guard let selectedTransaction = dataController.selectedTransaction else { return }
//        guard let selectedIndex = transactions.firstIndex(of: selectedTransaction) else { return }
//        managedObjectContext.delete(selectedTransaction)
//        dataController.save()
//
//        if selectedIndex < transactions.count {
//            dataController.selectedTransaction = transactions [selectedIndex]
//        } else {
//            let previousIndex = selectedIndex - 1
//            if previousIndex >= 0 {
//                dataController.selectedTransaction = transactions [previousIndex]
//            } else {
//                dataController.selectedTransaction = nil
//            }
//        }
//    }
}

struct TransactionListingView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListingView(transactions: [])
            .environmentObject(DataController())
    }
}
