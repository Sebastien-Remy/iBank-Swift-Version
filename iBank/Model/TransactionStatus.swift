//
//  TransactionStatus.swift
//  iBank
//
//  Created by Sebastien REMY on 21/11/2022.
//

import Foundation
import SwiftUI

enum TransactionStatus: Int, Comparable {
    static var allStatus = [TransactionStatus.planned, TransactionStatus.engaged, TransactionStatus.checked]
    
    case planned, engaged, checked
    
    var statusString: String {
        switch self {
        case .planned: return "Planned"
        case .engaged: return "Engaged"
        case .checked: return "Checked"
        }
    }
    
    var statusColor: Color {
        switch self {
        case .planned: return Constants.TransactionStatusColor.planned
        case .engaged: return Constants.TransactionStatusColor.engaded
        case .checked: return Constants.TransactionStatusColor.checked
        }
    }
    
    static func < (lhs: TransactionStatus, rhs: TransactionStatus) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}


