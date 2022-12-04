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
     
    @State var editedTransaction: Transaction
    
    private var dateFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }
    }
    
    var body: some View {
        
        Form {
            
            TextField("Title", text: $editedTransaction.transactionTitle)
            TextField("Subtitle", text: $editedTransaction.transactionsubTitle)
            HStack {
                Text(editedTransaction.transactionDebit, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                Text(editedTransaction.transactionCredit, format: .currency(code: Locale.current.currency?.identifier ?? ""))
            }
            HStack {
                Button(action: {
                    showing.toggle()
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    dataController.save()
                    showing.toggle()
                }) {
                    Text("Ok")
                }
            }
        }
        .frame(width: 200, height: 200)
    }
    
}

struct TransactionDetailSheetView_Previews: PreviewProvider {
    
    static var previews: some View {
        TransactionDetailSheetView(showing: .constant(true),
                                   editedTransaction: Transaction(context: DataController().container.viewContext,
                                                                                            date: Date(),
                                                                                            dateChecked: Date(),
                                                                                            title: "Test Title",
                                                                                            subTitle: "Test subTitle",
                                                                                            statusInt: 0
                                                                                           ))
            .environmentObject(DataController())
    }
}
