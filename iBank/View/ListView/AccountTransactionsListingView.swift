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
    @State private var editedTransaction: TransactionMain = TransactionMain()
    
    @FetchRequest var transactions: FetchedResults<TransactionMain>
    
    @State private var selectedTransactions = Set<TransactionMain.ID>()
    
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
                    Text(transaction.transactionDate, formatter: dateFormatter)
                        .foregroundColor(transaction.transactionStatus.statusColor)
                }
                
                TableColumn("Date") { transaction in
                    Text(transaction.transactionDate, formatter: dateFormatter)
                        .foregroundColor(transaction.transactionStatus.statusColor)
                }
                TableColumn("Checked") { transaction in
                    Text(transaction.transactionDateChecked, formatter: dateFormatter)
                        .foregroundColor(transaction.transactionStatus.statusColor)
                }
                TableColumn("Title") { transaction in
                    Text(transaction.transactionTitle)
                        .foregroundColor(transaction.transactionStatus.statusColor)
                }
                TableColumn("Debit") { transaction in
                    Text(transaction.transactionDebit, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                        .foregroundColor(transaction.transactionStatus.statusColor)
                }
                TableColumn("Crédit") { transaction in
                    Text(transaction.transactionCredit, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                        .foregroundColor(transaction.transactionStatus.statusColor)
                }
            }
            .onDeleteCommand(perform: { showingDeleteAlert.toggle() } )
            
            HStack {
                Text("Add transaction")
                
                Button(action: {
                    let t = TransactionMain(context: dataController.container.viewContext)
                    t.account = dataController.selectedAccount
                    t.transactionDate = Date()
                    t.transactionTitle = "Test"
                    dataController.save()
                    selectedTransactions = []
                    selectedTransactions.insert(t.id)
                },
                       label: { Text("plus") })
                Spacer()
                Button(action: {
                    
                    let t = TransactionMain(context: dataController.container.viewContext)
                    t.account = dataController.selectedAccount
                    t.transactionDate = Date()
                    t.transactionTitle = "Test"
                    dataController.save()
                    selectedTransactions = []
                    selectedTransactions.insert(t.id)
                    editedTransaction = t
                    showingTransactionSheetView.toggle() },
                       label: { Image(systemName: "plus")})
            }
            .padding()
            
            
            .sheet(isPresented: $showingTransactionSheetView,
                   content: {
                    TransactionDetailSheetView(showing: $showingTransactionSheetView, editedTransaction: $editedTransaction)
            
                
            })
            
            .alert(isPresented:$showingDeleteAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this \(selectedTransactions.count) transactions ?"),
                    message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        for id in selectedTransactions {
                            guard let t = transactions.first(where: {$0.id == id}) else { print ("error on delete transaction!")
                                return }
                            managedObjectContext.delete(t)
                            print("Delete")
                        }
                        selectedTransactions = []
                        dataController.save()
                    },
                    secondaryButton: .cancel()
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
