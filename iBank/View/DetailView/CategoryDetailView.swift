//
//  CategoryDetailView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct CategoryDetailView: View {
  
    @ObservedObject var category: Category
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        Form {
            TextField("Category: ", text: $category.categoryName)
        }
        // Save on Change
        .onChange(of: category.categoryName, perform: dataController.enqueueSave)
        
        // Disable when category deleted
        .disabled(category.managedObjectContext == nil)
    }
}
struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let category = Category(context: dataController.container.viewContext,
                              name: "Tes")
        CategoryDetailView(category: category)
            .environmentObject(dataController)
    }
}
