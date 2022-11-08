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
    
    var body: some View {
        Form {
            TextField("Third: ", text: $third.thirdName)
        }
        // Save on Change
        .onChange(of: third.thirdName, perform: dataController.enqueueSave)
        
        // Disable when third deleted
        .disabled(third.managedObjectContext == nil)
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
