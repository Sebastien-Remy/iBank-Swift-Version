//
//  ContentView.swift
//  iBank
//
//  Created by Sebastien REMY on 08/11/2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var dataController: DataController
    @State private var colVis: NavigationSplitViewVisibility = .all
    
    var body: some View {
        
        NavigationSplitView(columnVisibility: $colVis,
                            sidebar:  { SideBarView() } ,
                            content: { ContentView() },
                            detail: { DetailView()}
        )
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(DataController())
    }
}
