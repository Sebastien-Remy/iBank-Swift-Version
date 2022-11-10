//
//  AccountListingView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct AccountListingView: View {

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var accounts: FetchedResults<Account>
    
    
    var body: some View {
        VStack {
         
            List(accounts, selection: $dataController.selectedAccount) { account in
                Text(account.accountName)
                    .tag(account)
            }
            .padding([.leading])
            .contextMenu {
                Button("Delete", role: .destructive, action: deleteSelected)
            }
            HStack {
                Text("Add account")
                Spacer()
                Button(action: addNew, label: { Image(systemName: "plus")})
            }
            .padding()
        }
    }
    
    func addNew() {
        // Create account
        let account = Account(context: managedObjectContext)
        account.accountName = "New account"
        account.originalBalance = 0
        
        // Save
        dataController.save()
        
        // Select just added account
        dataController.selectedAccount = account
    }
    
    func deleteSelected() {
        guard let selectedAccount = dataController.selectedAccount else { return }
        guard let selectedIndex = accounts.firstIndex(of: selectedAccount) else { return }
        managedObjectContext.delete(selectedAccount)
        dataController.save()
        
        if selectedIndex < accounts.count {
            dataController.selectedAccount = accounts [selectedIndex]
        } else {
            let previousIndex = selectedIndex - 1
            if previousIndex >= 0 {
                dataController.selectedAccount = accounts[previousIndex]
            } else {
                dataController.selectedAccount = nil
            }
        }
    }
}

struct AccountListingView_Previews: PreviewProvider {
    static var previews: some View {
        AccountListingView()
    }
}
