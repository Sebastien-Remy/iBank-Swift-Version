//
//  Project-CoreDataHelper.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import Foundation

extension Project {
    var projectName: String {
        get { name ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            name = newValue
        }
    }
}
