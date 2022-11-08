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
                Divider()
                AccountListingView()
                Divider()
                CategoryListingView()
                Divider()
                ThirdListingView()
                Divider()
                ProjectListingView()
                Spacer()
            }
            .frame(minWidth: 250)
            
        } detail: {
            switch dataController.currentSelection {
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
            default:
                Text("Select something on the left panel")
            }
        
    
        }
        
    }
    func action() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        ContentView().environmentObject(dataController)
    }
}
