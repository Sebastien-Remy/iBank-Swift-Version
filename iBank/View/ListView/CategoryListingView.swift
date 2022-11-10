//
//  CategoryListingView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct CategoryListingView: View {
   
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var categories: FetchedResults<Category>
    
    
    var body: some View {
        VStack {

            List(categories, selection: $dataController.selectedCategory) { category in
                Text(category.categoryName)
                    .tag(category)
            }
            .padding([.leading])
            .contextMenu {
                Button("Delete category", role: .destructive, action: deleteSelected)
            }
            HStack {
                Text("Add category")
                Spacer()
                Button(action: addNew, label: { Image(systemName: "plus")})
            }
            .padding()
        }
    }
    
    func addNew() {
        // Create category
        let category = Category(context: managedObjectContext)
        category.categoryName = "New Category"
      
        
        // Save
        dataController.save()
        
        // Select just added account
        dataController.selectedCategory = category
    }
    
    func deleteSelected() {
        guard let selectedCategory = dataController.selectedCategory else { return }
        guard let selectedIndex = categories.firstIndex(of: selectedCategory) else { return }
        managedObjectContext.delete(selectedCategory)
        dataController.save()
        
        if selectedIndex < categories.count {
            dataController.selectedCategory = categories [selectedIndex]
        } else {
            let previousIndex = selectedIndex - 1
            if previousIndex >= 0 {
                dataController.selectedCategory = categories[previousIndex]
            } else {
                dataController.selectedCategory = nil
            }
        }
    }
}
struct CategoryListingView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListingView()
    }
}
