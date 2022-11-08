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
            AccountListingView()
                .frame(minWidth: 250)
        } detail: {
            if let selectedReview = dataController.selectedAccount {
                AccountDetailView(account: selectedReview)
                    .padding()
            } else {
                Text("Please select a review")
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
