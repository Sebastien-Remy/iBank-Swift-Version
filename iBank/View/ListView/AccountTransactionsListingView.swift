//
//  TransactionListingView.swift
//  iBank
//
//  Created by Sebastien REMY on 10/11/2022.
//

import SwiftUI

struct AccountTransactionsListingView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var dataController: DataController
    
    @State private var showingTransactionSheetView = false
    @State private var showingDeleteAlert = false
    @State private var editedTransaction: TransactionMain = TransactionMain(context: NSManagedObjectContext(.privateQueue))
    
    @FetchRequest var transactions: FetchedResults<TransactionMain>
    
    @State private var selectedTransactions = Set<TransactionMain.ID>()
    @State private var transactionMainToDelete: TransactionMain.ID? = nil
    
    private var dateFormatter: DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter
        }
    }
    
    init(account: Account) {
        _transactions = FetchRequest<TransactionMain>(sortDescriptors: [SortDescriptor(\.dateChecked)],
                                                      predicate: NSPredicate(format: "%K == %@",
                                                                             #keyPath(TransactionMain.account),
                                                                             account))
    }
    
    var body: some View {
        
        
        VStack {
            
            Table(transactions, selection: $selectedTransactions) {
                
                TableColumn("Date") { transaction in
                    HStack {
                        Spacer()
                        Text(transaction.transactionDate, formatter: dateFormatter)
                            .foregroundColor(transaction.transactionStatus.statusColor)
                    }
                }
                .width(min: 50, ideal: 60)
                
                
                TableColumn("Checked") { transaction in
                    HStack {
                        Spacer()
                        Text(transaction.transactionDateChecked, formatter: dateFormatter)
                            .foregroundColor(transaction.transactionStatus.statusColor)
                    }
                }
                .width(min: 50, ideal: 60)
                
                TableColumn("Title") { transaction in
                    Text(transaction.transactionTitle)
                        .foregroundColor(transaction.transactionStatus.statusColor)
                }
                .width(min: 75, ideal: 150)
                
                TableColumn("Debit") { transaction in
                    HStack {
                        Spacer()
                        Text(transaction.transactionDebit, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                            .foregroundColor(transaction.transactionStatus.statusColor)
                    }
                }
                .width(min: 50, ideal: 75)
                
                TableColumn("Crédit") { transaction in
                    HStack {
                        Spacer()
                        Text(transaction.transactionCredit, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                            .foregroundColor(transaction.transactionStatus.statusColor)
                    }
                    
                }
                .width(min: 50, ideal: 75)
                
                TableColumn("") { transaction in
                    HStack {
                        Spacer()
                        Button(action: { },
                               label: { Image(systemName: "pencil")})
                        Spacer()
                        Button(action: {
                            transactionMainToDelete = transaction.id
                            showingDeleteAlert.toggle()
                        },
                               label: { Image(systemName: "trash")})
                        Spacer()
                    }
                }
                .width(min: 30, ideal: 30)
                
            }
            .onTapGesture(count: 2) {
                print(selectedTransactions)
            }
            .onDeleteCommand(perform: { showingDeleteAlert.toggle() } )
            
            
            HStack {
                Text("Add transaction")
                
                Spacer()
                Button(action: {
                    
                    // Create Main
                    let t = TransactionMain(context: dataController.container.viewContext)
                    t.account = dataController.selectedAccount
                    t.transactionDate = Date()
                    t.transactionTitle = "Test"
                    
                    // Create Detail
                    let d = TransactionDetail(context: dataController.container.viewContext)
                    d.detailDate = t.transactionDate
                    
                    // Add detail to main
                    t.transactionDetails = NSSet(object: d)
                    
                    // Save
                    dataController.save()
                    
                    // Select
                    selectedTransactions = []
                    selectedTransactions.insert(t.id)
                    
                    // Show new transaction in sheet window
                    editedTransaction = t
                    showingTransactionSheetView.toggle()
                    
                },
                       label: { Image(systemName: "plus")
                    
                })
            }
            .padding()
            
            
            .sheet(isPresented: $showingTransactionSheetView,
                   content: {
                TransactionDetailSheetView(showing: $showingTransactionSheetView,
                                           editedTransaction: $editedTransaction)
            })
            
            .alert(isPresented:$showingDeleteAlert) {
                
                // Construct alert title
                var alertTitle = "Are you sure you want to delete "
                if transactionMainToDelete != nil {
                    // Delete by clicking row button
                    alertTitle += "this transaction"
                } else {
                    // Delete selection by press DEL on selection
                    alertTitle += "Are you sure you want to delete \(selectedTransactions.count) transaction"
                    if selectedTransactions.count > 1 { alertTitle += "s" }
                }
                alertTitle += "?"
                
                return Alert(
                    title: Text(alertTitle),
                    message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        
                        if transactionMainToDelete == nil {
                            // Delete selection by press DEL on selection
                            for id in selectedTransactions {
                                guard let t = transactions.first(where: {$0.id == id}) else { print ("error on delete transaction!")
                                    return }
                                managedObjectContext.delete(t)
                            }
                            
                            // Clear selection
                            selectedTransactions = []
                            
                        } else {
                            // Delete by clicking row button
                            
                            guard let t = transactions.first(where: {$0.id == transactionMainToDelete}) else { return }
                            managedObjectContext.delete(t)
                            
                            // Remove from selection
                            selectedTransactions.remove(t.id)
                            
                            // Clear reference
                            transactionMainToDelete = nil
                        }
                        
                        // Save
                        dataController.save()
                    },
                    secondaryButton: .cancel() {
                        // Clear reference
                        transactionMainToDelete = nil
                    }
                )
            }
            
        }
    }
}

struct AccountTransactionsListingView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTransactionsListingView(account: Account())
            .environmentObject(DataController())
    }
}
