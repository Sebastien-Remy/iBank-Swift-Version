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
  
    @State private var isExpanded = false
    
    var body: some View {
        DisclosureGroup("Category", isExpanded: $isExpanded) {
            VStack {
                Form {
                    TextField("Name: ", text: $category.categoryName)
                    
                    ColorPicker("Color:", selection: $category.categoryColor)
                }
                // Save on Change
                .onChange(of: category.categoryName, perform: dataController.enqueueSave)
                .onChange(of: category.categoryColor, perform: dataController.enqueueSave)
                
                // Disable when category deleted
                .disabled(category.managedObjectContext == nil)
                
            }
        }
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
