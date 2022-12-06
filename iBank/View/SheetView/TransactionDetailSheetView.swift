//
//  TransactionDetailSheetView.swift
//  iBank
//
//  Created by Sebastien REMY on 04/12/2022.
//

import SwiftUI

struct TransactionDetailSheetView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @Binding var showing: Bool  
    @Binding var editedTransaction: TransactionMain
    
    private var dateFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }
    }
    
    private var currencyFormatter: NumberFormatter{
        get {
            let formatter = NumberFormatter()
            formatter.currencyCode = Locale.current.currency?.identifier ?? ""
            return formatter
        }
    }
    
    var body: some View {
        
        Form {
            
            TextField("Title:", text: $editedTransaction.transactionTitle)
            TextField("Subtitle:", text: $editedTransaction.transactionsubTitle)
            TextField("amount:",
                      value: $editedTransaction.mainTransactionDetail.amount,
                      formatter: currencyFormatter
            )
         
            
            HStack {
                Text(editedTransaction.transactionDebit,
                     format: .currency(code: Locale.current.currency?.identifier ?? ""))
                Text(editedTransaction.transactionCredit,
                     format: .currency(code: Locale.current.currency?.identifier ?? ""))
            }
            HStack {
                Spacer()

                Button(action: {
                    dataController.save()
                    showing.toggle()
                }) {
                    Text("Dismiss")
                }
            }
        }
        .frame(width: 200, height: 200)
        .padding()
    }
    
}

struct TransactionDetailSheetView_Previews: PreviewProvider {

    static var previews: some View {
        
        TransactionDetailSheetView(showing: .constant(true),
                                   editedTransaction: .constant(TransactionMain(context: DataController().container.viewContext)) )
            .environmentObject(DataController())
    }
}
