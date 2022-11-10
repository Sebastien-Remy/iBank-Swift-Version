//
//  AccountDetailView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct AccountDetailView: View {
    
    @ObservedObject var account: Account
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
        
    var body: some View {
        VStack {
            Form {
                TextField("Account: ", text: $account.accountName)
                TextField("Original balance: ", value: $account.originalBalance, format: .number)
            }
            // Save on Change
            .onChange(of: account.accountName, perform: dataController.enqueueSave)
            .onChange(of: account.originalBalance, perform: dataController.enqueueSave)
            
            // Disable when review deleted
            .disabled(account.managedObjectContext == nil)
            
            List {
                ForEach(account.accountTransactions) { transaction in
                    HStack {
                        Text(transaction.transactionDate, style: .date)
                        Text(transaction.transactionName)
                    }
                }
            }
            Button("Add") {
                let t = Transaction(context: managedObjectContext)
                t.account = account
                t.transactionDate = Date()
                t.transactionName = "test"
              
                
                try? managedObjectContext.save()
            }
            
        }
    }
}

struct AccountDetailView_Preview: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let account = Account(context: dataController.container.viewContext,
                              name: "Tes",
                              originalBalance: 52.0)
        AccountDetailView(account: account)
            .environmentObject(dataController)
    }
    
}
