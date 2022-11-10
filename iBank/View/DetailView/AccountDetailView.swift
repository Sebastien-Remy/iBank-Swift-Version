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
            
            List(account.accountTransactions, selection: $dataController.selectedTransaction) { transaction in
                HStack {
                    Text(transaction.transactionDate, style: .date)
                    Text(transaction.transactionName)
                }
                    .tag(transaction)
            }
            .padding([.leading])
            .contextMenu {
                Button("Delete transaction", role: .destructive, action: deleteSelected)
            }
            
            
            // DEBUG ONLY BUTTON
            Button("Add") {
                let t = Transaction(context: managedObjectContext)
                t.account = account
                t.transactionDate = Date()
                t.transactionName = "test"
              
                
                try? managedObjectContext.save()
            }
            
        }
    }
    
    func addNew() {
        // Create detail
        let project = Project(context: managedObjectContext)
        project.projectName = "New Project"
        
        
        // Save
        dataController.save()
        
        // Select just added account
        dataController.selectedProject = project
    }
    
    func deleteSelected() {
        guard let selectedTransaction = dataController.selectedTransaction else { return }
        guard let selectedIndex = account.accountTransactions.firstIndex(of: selectedTransaction) else { return }
        managedObjectContext.delete(selectedTransaction)
        dataController.save()
        
        if selectedIndex < account.accountTransactions.count {
            dataController.selectedTransaction = account.accountTransactions [selectedIndex]
        } else {
            let previousIndex = selectedIndex - 1
            if previousIndex >= 0 {
                dataController.selectedTransaction = account.accountTransactions[previousIndex]
            } else {
                dataController.selectedTransaction = nil
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
