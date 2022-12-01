//
//  DetailView.swift
//  iBank
//
//  Created by Sebastien REMY on 01/12/2022.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        VStack {
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
            Spacer()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
            .environmentObject(DataController())
    }
}
