//
//  ContentView.swift
//  iBank
//
//  Created by Sebastien REMY on 01/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        VStack {
            if let accoundId = dataController.selectedAccount {
                BalanceView()
                AccountTransactionsListingView(account: accoundId)
            }
            else {
                Spacer()
                Text ("Select an account")
                Spacer()
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
