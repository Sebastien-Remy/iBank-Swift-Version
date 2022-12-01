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
                ColorPicker("Color", selection: $account.accountColor)
                TextField("Original balance: ",
                          value: $account.originalBalance,
                          format: .currency(code: Locale.current.currency?.identifier ?? ""))
            }
            // Save on Change
            .onChange(of: account.accountName, perform: dataController.enqueueSave)
            .onChange(of: account.accountColor, perform: dataController.enqueueSave)
            .onChange(of: account.originalBalance, perform: dataController.enqueueSave)
            
            // Disable when review deleted
            .disabled(account.managedObjectContext == nil)
            
            
            Spacer()
           
        }
    }
}

struct AccountDetailView_Preview: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
    
        let account = Account(context: dataController.container.viewContext,
                              name: "Test",
                              originalBalance: 0.0)
        AccountDetailView(account: account)
            .environmentObject(dataController)
    }
    
}
