//
//  ProjectDetailView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct ProjectDetailView: View {
    @ObservedObject var project: Project
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        Form {
            TextField("Project: ", text: $project.projectName)
            ColorPicker("Color", selection: $project.projectColor)
        }
        // Save on Change
        .onChange(of: project.projectName, perform: dataController.enqueueSave)
        
        .onChange(of: project.projectColor, perform: dataController.enqueueSave)
        
        // Disable when project deleted
        .disabled(project.managedObjectContext == nil)
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let project = Project(context: dataController.container.viewContext,
                          name: "Tes")
        ProjectDetailView(project: project)
            .environmentObject(dataController)
    }
}
