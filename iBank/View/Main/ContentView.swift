//
//  ContentView.swift
//  iBank
//
//  Created by Sebastien REMY on 01/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var dataController: DataController
    
    
    @State var transactions: [Transaction] = []
    
    var body: some View {
        VStack {
            
           BalanceView()
            
            List(transactions, selection: $dataController.selectedTransaction) { transaction in
                HStack {
                    Text(transaction.transactionDate, style: .date)
                    Text(transaction.transactionTitle)
                    Text(transaction.account?.accountName ?? "Select Account")
                    Text(transaction.third?.thirdName ?? "Select third")
                }
                //                .contextMenu {
                //                    if dataController.selectedTransaction != nil {
                //                        Button("Delete transaction", role: .destructive, action: deleteSelected)
                //                    }
                //                }
                .tag(transaction)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataController())
    }
}
