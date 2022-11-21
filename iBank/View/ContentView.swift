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
            VStack {
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
            
        } detail: {
            switch dataController.selectedView {
            case .account:
                if let selectedAccount = dataController.selectedAccount {
                    AccountDetailView(account: selectedAccount)
                        .padding()
                } else {
                    Text("Please select an account")
                }
            case .category:
                if let selectedCategory = dataController.selectedCategory {
                    CategoryDetailView(category: selectedCategory)
                        .padding()
                } else {
                    Text("Please select a category")
                }
            case .third:
                if let selectedThird = dataController.selectedThird {
                    ThirdDetailView(third: selectedThird)
                        .padding()
                } else {
                    Text("Please select a third")
                }
            case .project:
                if let selectedProject = dataController.selectedProject {
                    ProjectDetailView(project: selectedProject)
                        .padding()
                } else {
                    Text("Please select a project")
                }
            }
        
    
        }
        
    }
    func action() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataController())
    }
}
