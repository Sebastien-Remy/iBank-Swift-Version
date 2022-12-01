//
//  ThirdDetailView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct ThirdDetailView: View {
    
    @ObservedObject var third: Third
    @EnvironmentObject var dataController: DataController
    
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup("Third", isExpanded: $isExpanded) {
            VStack {
                Form {
                    TextField("Name: ", text: $third.thirdName)
                    ColorPicker("Color:", selection: $third.thirdColor)
                }
                // Save on Change
                .onChange(of: third.thirdName, perform: dataController.enqueueSave)
                
                .onChange(of:third.thirdColor, perform: dataController.enqueueSave)
                
                // Disable when third deleted
                .disabled(third.managedObjectContext == nil)
                
            }
        }
    }
}

struct ThirdDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let third = Third(context: dataController.container.viewContext,
                                name: "Tes")
        ThirdDetailView(third: third)
            .environmentObject(dataController)
    }
}
