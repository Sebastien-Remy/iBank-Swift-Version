//
//  Project-ListingView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct ProjectListingView: View {
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var projects: FetchedResults<Project>
    
    
    var body: some View {
        VStack {
            
            List(projects, selection: $dataController.selectedProject) { project in
                HStack {
                    Image(systemName: project.projectIconName)
                        .foregroundColor(project.projectColor)
                    Text(project.projectName)
                    
                }
                .tag(project)
            }
            .padding([.leading])
            .contextMenu {
                Button("Delete project", role: .destructive, action: deleteSelected)
            }
            HStack {
                Text("Add project")
                Spacer()
                Button(action: addNew, label: { Image(systemName: "plus")})
            }
            .padding()
        }
    }
    
    func addNew() {
        // Create category
        let project = Project(context: managedObjectContext)
        project.projectName = "New Project"
        
        
        // Save
        dataController.save()
        
        // Select just added account
        dataController.selectedProject = project
    }
    
    func deleteSelected() {
        guard let selectedProject = dataController.selectedProject else { return }
        guard let selectedIndex = projects.firstIndex(of: selectedProject) else { return }
        managedObjectContext.delete(selectedProject)
        dataController.save()
        
        if selectedIndex < projects.count {
            dataController.selectedProject = projects [selectedIndex]
        } else {
            let previousIndex = selectedIndex - 1
            if previousIndex >= 0 {
                dataController.selectedProject = projects[previousIndex]
            } else {
                dataController.selectedProject = nil
            }
        }
    }
}

struct ProjectListingView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListingView()
            .environmentObject(DataController())
    }
}
