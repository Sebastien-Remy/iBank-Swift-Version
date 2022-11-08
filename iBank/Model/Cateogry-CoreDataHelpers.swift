//
//  CateogryCoreDataHelpers.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import Foundation
import CoreData

extension Category {
    
    convenience init(context: NSManagedObjectContext,
                     name: String) {
        self.init(context: context)
        self.name = name
    }
    
    var categoryName: String {
        get { name ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            name = newValue
        }
    }
}
