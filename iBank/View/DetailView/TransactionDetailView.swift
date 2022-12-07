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
    @State private var transactionSelectedAccount: Account
    @State private var transactionSelectedCategory: Category
    @State private var transactionSelectedThird: Third
    @State private var transactionSelectedProject: Project
    
    
    @FetchRequest private var accounts: FetchedResults<Account>
    @FetchRequest private var categories: FetchedResults<Category>
    @FetchRequest private var thirds: FetchedResults<Third>
    @FetchRequest private var projects: FetchedResults<Project>
    
    init(moc: NSManagedObjectContext) {
        // Acounts
        let accountFetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        accountFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Account.name, ascending: true)]
        accountFetchRequest.predicate = NSPredicate(value: true)
        self._accounts = FetchRequest(fetchRequest: accountFetchRequest)
        
        
        // Categories
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
        categoryFetchRequest.predicate = NSPredicate(value: true)
        self._categories = FetchRequest(fetchRequest: categoryFetchRequest)
        
        // Thirds
        let thirdFetchRequest: NSFetchRequest<Third> = Third.fetchRequest()
        thirdFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Third.name, ascending: true)]
        thirdFetchRequest.predicate = NSPredicate(value: true)
        self._thirds = FetchRequest(fetchRequest: thirdFetchRequest)
        
        
        // Projects
        let projectFetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        projectFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.name, ascending: true)]
        projectFetchRequest.predicate = NSPredicate(value: true)
        self._projects = FetchRequest(fetchRequest: projectFetchRequest)
        
        do {
            let tempAccounts = try moc.fetch(accountFetchRequest)
            let tempCategories = try moc.fetch(categoryFetchRequest)
            let tempthirds = try moc.fetch(thirdFetchRequest)
            let tempProjects = try moc.fetch(projectFetchRequest)
            
            if(tempAccounts.count > 0) {
                self._transactionSelectedAccount = State(initialValue: tempAccounts.first!)
            } else {
                self._transactionSelectedAccount = State(initialValue: Account(context: moc))
            }
            
            if(tempCategories.count > 0) {
                self._transactionSelectedCategory = State(initialValue: tempCategories.first!)
            } else {
                self._transactionSelectedCategory = State(initialValue: Category(context: moc))
            }
            
            if(tempthirds.count > 0) {
                self._transactionSelectedThird = State(initialValue: tempthirds.first!)
            } else {
                self._transactionSelectedThird = State(initialValue: Third(context: moc))
            }
            
            if(tempProjects.count > 0) {
                self._transactionSelectedProject = State(initialValue: tempProjects.first!)
            } else {
                self._transactionSelectedProject = State(initialValue: Project(context: moc))
            }
            
            if (tempAccounts.count < 1) || (tempCategories.count < 1) ||  (tempthirds.count < 1) || (tempProjects.count < 1 ) {
                moc.delete(transactionSelectedAccount)
                moc.delete(transactionSelectedCategory)
                moc.delete(transactionSelectedThird)
                moc.delete(transactionSelectedProject)
            }
            
        } catch {
            fatalError("Init Problem")
        }
    }
        
    
    
    var body: some View {
        VStack {
            Group {
                if (accounts.count > 0) {
                    Picker("Account", selection: $transactionSelectedAccount) {
                        ForEach(accounts) { (account: Account) in
                            Text(account.accountName).tag(account)
                        }
                    }
                } else {
                    Text("There is not account in iBank!")
                }
                
                if (categories.count > 0) {
                    Picker("Category", selection: $transactionSelectedCategory) {
                        ForEach(categories) { (category: Category) in
                            Text(category.categoryName).tag(category)
                        }
                    }
                }
                else {
                    Text("There is not category in iBank!")
                }
                
                if (thirds.count > 0) {
                    Picker("Third", selection: $transactionSelectedThird) {
                        ForEach(thirds) { (third: Third) in
                            Text(third.thirdName).tag(third)
                        }
                    }
                } else {
                    Text("There is not third in iBank!")
                }
            }
            if (projects.count > 0) {
                Picker("Project", selection: $transactionSelectedProject) {
                    ForEach(projects) { (project : Project) in
                        Text(project.projectName).tag(project)
                    }
                }
            } else {
                Text("There is not project in iBank!")
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
            
            DatePicker("\(transactionStatus == .checked ? "Checked on:" : "Will be checked on:")",
                           selection: $transactionDateChecked,
                       displayedComponents: [.date])
      
            
            TextField("Notes: ", text: $transactionNotes)
        }
        .padding()
        
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
        .padding([.trailing, .bottom])
        .interactiveDismissDisabled()
    }
}



struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(moc: DataController().container.viewContext)

            .environmentObject(DataController())
    }
}
