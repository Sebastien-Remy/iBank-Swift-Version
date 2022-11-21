//
//  ThirdListingView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct ThirdListingView: View {
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var thirds: FetchedResults<Third>
    
    
    var body: some View {
        VStack {
            List(thirds, selection: $dataController.selectedThird) { third in
                HStack {
                    Image(systemName: third.thirdIconName)
                        .foregroundColor(third.thirdColor)
                    Text(third.thirdName)
                }
                    .tag(third)
            }
            .padding([.leading])
            .contextMenu {
                Button("Delete third", role: .destructive, action: deleteSelected)
            }
            HStack {
                Text("Add third")
                Spacer()
                Button(action: addNew, label: { Image(systemName: "plus")})
            }
            .padding()
        }
    }
    
    func addNew() {
        // Create third
        let third = Third(context: managedObjectContext)
        third.thirdName = "New Third"
        
        
        // Save
        dataController.save()
        
        // Select just added account
        dataController.selectedThird = third
    }
    
    func deleteSelected() {
        guard let selectedThird = dataController.selectedThird else { return }
        guard let selectedIndex = thirds.firstIndex(of: selectedThird) else { return }
        managedObjectContext.delete(selectedThird)
        dataController.save()
        
        if selectedIndex < thirds.count {
            dataController.selectedThird = thirds [selectedIndex]
        } else {
            let previousIndex = selectedIndex - 1
            if previousIndex >= 0 {
                dataController.selectedThird = thirds[previousIndex]
            } else {
                dataController.selectedThird = nil
            }
        }
    }
}

struct ThirdListingView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdListingView()
            .environmentObject(DataController())
    }
}
