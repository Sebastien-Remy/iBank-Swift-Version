//
//  BalanceView.swift
//  iBank
//
//  Created by Sebastien REMY on 01/12/2022.
//

import SwiftUI

struct BalanceView: View {
    var body: some View {
        HStack {
            Spacer()
            BalanceItemView(amount: 0.0, status: .checked)
            BalanceItemView(amount: 0.0, status: .engaged)
            BalanceItemView(amount: 0.0, status: .planned)
            
            Spacer()
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceView()
    }
}
