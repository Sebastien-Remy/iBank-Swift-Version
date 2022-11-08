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
    
    @AppStorage("id") var id = 1
    
    var body: some View {
        List(accounts, selection: $dataController.selectedAccount) { account in
            Text(account.accountName)
                .tag(account)
        }
//        .onDeleteCommand(perform: deleteSelected) // isn't called here Known bug that Apple are working to fix
        .contextMenu {
            Button("Delete", role: .destructive, action: deleteSelected)
        }
        .toolbar{
            Button(action: addAccount) {
                Label("Add review", systemImage: "plus")
            }
            Button(action: deleteSelected, label: { Label("Delete", systemImage: "trash") })
        }
    }
    
    func addAccount() {
        // Create account
        let account = Account(context: managedObjectContext)
        account.name = "Account"
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
