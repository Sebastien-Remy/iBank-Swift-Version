//
//  ContentView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationSplitView {
            List() {
                Section(content: {
                    Text("Accounts")
                    AccountListingView()
                        .frame(minWidth: 500)
                })
                Section(content: {
                    Text("Categories")
                })
                Spacer()
            }
            .padding()
        } detail: {
            if let selectedAccount = dataController.selectedAccount {
                AccountDetailView(account: selectedAccount)
                    .padding()
            } else {
                Text("Please select a review")
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        ContentView().environmentObject(dataController)
    }
}
