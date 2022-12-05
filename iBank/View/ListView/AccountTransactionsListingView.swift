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
                            managedObjectContext.delete(transaction) },
                               label: { Image(systemName: "trash")})
                        Spacer()
                    }
                }
                .width(min: 30, ideal: 30)
                
            }
            .onDeleteCommand(perform: { showingDeleteAlert.toggle() } )
            
            
            HStack {
                Text("Add transaction")
                
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
