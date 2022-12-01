//
//  SplitViewDetailView.swift
//  iBank
//
//  Created by Sebastien REMY on 01/12/2022.
//

import SwiftUI

struct SideBarView: View {

    @EnvironmentObject var dataController: DataController

    var body: some View {VStack {
        Picker("", selection: $dataController.selectedView) {
            
            // Bank account
            Image(systemName: Constants.Account.iconName)
                .tag(IBankEntity.account)
            
            // Category
            Image(systemName: Constants.Category.iconName).tag(IBankEntity.category)
            
            // Third
            Image(systemName: Constants.Category.iconName)
                .tag(IBankEntity.third)
            
            // Project
            Image(systemName: Constants.Project.iconName)
                .tag(IBankEntity.project)
        }
        .pickerStyle(.segmented)
        .padding()
        
        Divider()
        
        switch dataController.selectedView {
        case .account:
            AccountListingView()
        case .category:
            CategoryListingView()
        case.third:
            ThirdListingView()
        case .project:
            ProjectListingView()
        }
    }
    .frame(minWidth: 250)
    }
}

struct SplitViewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView()
            .environmentObject(DataController())
    }
}
