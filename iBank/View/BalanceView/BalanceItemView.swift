//
//  BalanceItemView.swift
//  iBank
//
//  Created by Sebastien REMY on 01/12/2022.
//

import SwiftUI

struct BalanceItemView: View {
    
    var amount: Double
    var status: TransactionStatus
    
    var body: some View {
        VStack {
            Text(amount, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                .font(.title2)
                .foregroundColor(status.statusColor.opacity(0.8))
            Text (status.statusString)
                .font(.title3)
        }
        .padding()
        .frame(width: 160,height: 60, alignment: .center)
        .background(status.statusColor.opacity(0.1))
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(status.statusColor.opacity(0.25), lineWidth: 4)
        )
        .padding()
    }
}

struct BalanceItemView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceItemView(amount: 1200000, status: .planned)
    }
}
