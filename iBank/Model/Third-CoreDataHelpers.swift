//
//  Third-CoreDataHelpers.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import Foundation
import CoreData
import SwiftUI

extension Third {
    
    convenience init(context: NSManagedObjectContext,
                     name: String) {
        self.init(context: context)
        self.name = name
        self.iconName = Constants.Third.iconName
    }
    
    var thirdName: String {
        get { name ?? "" }
        set {
            guard managedObjectContext  != nil else { return }
            name = newValue
        }
    }
    var thirdIconName: String {
        get {
            let systemName = iconName ?? Constants.Third.iconName
            if NSImage(systemSymbolName: systemName, accessibilityDescription: "") == nil { return Constants.Third.iconName }
            return systemName
        }
        set {
            guard managedObjectContext  != nil else { return }
            iconName = newValue
        }
    }
    
    var thirdColor: Color {
        get { Color(fromHexString: colorAsHex) ?? Color.primary }
        set {
            guard managedObjectContext  != nil else { return }
            colorAsHex = newValue.toHexString()
        }
    }
}
