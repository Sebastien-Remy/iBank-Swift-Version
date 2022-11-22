//
//  TransactionDetailView.swift
//  iBank
//
//  Created by Sebastien REMY on 21/11/2022.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var dataController: DataController
    
    @State private var transactionDate = Date()
    @State private var transactionDateChecked = Date()
    @State private var transactionTitle = ""
    @State private var transactionSubTitle = ""
    @State private var transactionAmount = 0.0
    @State private var transactionNotes = ""
    @State private var transactionStatus = TransactionStatus.planned
    
    
    @FetchRequest private var accounts: FetchedResults<Account>
    @State private var transactionSelectedAccount: Account
    
    init(moc: NSManagedObjectContext) {
        let accountFetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        accountFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Account.name, ascending: false)]
        accountFetchRequest.predicate = NSPredicate(value: true)
        self._accounts = FetchRequest(fetchRequest: accountFetchRequest)
        do {
            let tempAccounts = try moc.fetch(accountFetchRequest)
            if(tempAccounts.count > 0) {
                self._transactionSelectedAccount = State(initialValue: tempAccounts.first!)
            } else {
                self._transactionSelectedAccount = State(initialValue: Account(context: moc))
                moc.delete(transactionSelectedAccount)
            }
        } catch {
            fatalError("Init Problem")
        }
    }
    
    
    var body: some View {
        VStack {
            if (accounts.count > 0) {
                Picker("Account", selection: $transactionSelectedAccount) {
                    ForEach(accounts) { (item: Account) in
                        Text(item.accountName).tag(item)
                    }
                }.padding()
            } else {
                Text("There is not account in iBank!")
            }
            
            
            DatePicker("Date:",
                       selection: $transactionDate,
                       displayedComponents: [.date])
            
            TextField("Title:", text: $transactionTitle)
            
            TextField("Sub Title:", text: $transactionSubTitle)
            
            TextField("Amount: ", value: $transactionAmount,
                      format: .currency(code: Locale.current.currency?.identifier ?? ""))
            
            Picker("Status:", selection: $transactionStatus) {
                ForEach(TransactionStatus.allStatus, id: \.statusString) { status in
                    Text("\(status.statusString)")
                        .tag(status)
                }
            }
            .pickerStyle(.segmented)
            
            if transactionStatus == .checked {
                DatePicker("Checked on:",
                           selection: $transactionDateChecked,
                           displayedComponents: [.date])
            }
            
            

            TextField("Notes: ",text: $transactionNotes)
            
//            Text("Notes:")
//            TextEditor(text: $transactionNotes)  // <- CREATE A PROBLEM WITH FOLLOWIN HSTACK !!
//                .multilineTextAlignment(.leading)
        
            
            HStack {
                
                Spacer()
                
                Button("Cancel", action: {
                    // Cancel
                    dismiss()
                })
                .keyboardShortcut(.cancelAction)
                
                Button("Save", action: {
                    // Save
                    dismiss()
                })
                .keyboardShortcut(.defaultAction)
            }
        }
        .interactiveDismissDisabled()
        .padding()
    }
}



//struct TransactionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionDetailView(moc: Environment(\.managedObjectContext))
//
//            .environmentObject(DataController())
//    }
//}
