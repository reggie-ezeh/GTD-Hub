//
//  InboxPageView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/19/23.
//

import SwiftUI

enum InboxAction: Identifiable {
    case createProject(InboxItem)
    case addToNextActions(InboxItem)
    case addAsReference(InboxItem)

    var id: String {
        switch self {
        case .createProject(let item):
            return item.id
        case .addToNextActions(let item):
            return item.id
        case .addAsReference(let item):
            return item.id
        }
    }
}


struct InboxPageView: View {
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @EnvironmentObject var allProjectsViewModel: AllProjectsViewModel
    @EnvironmentObject var nextActionsViewModel: NextActionsViewModel
    @EnvironmentObject var referencesViewModel: ReferencesViewModel

    @State private var selectedInboxItem: InboxItem?
    @State private var showCreateProject = false
    @State private var showAddToProject = false
    @State private var showAddToNextActions = false
    @State private var showAddAsReference = false
    @State private var showActionSheet = false
    @State private var currentAction: InboxAction?
    
    @State private var inboxItemMovedOut = false


    
    var body: some View {

            List {
                ForEach(inboxViewModel.allInboxItems.sorted { $0.captureDate > $1.captureDate }) { item in
                    HStack {
                        InboxItemView(inboxItem: item)
                        Spacer()
                        Button(action: {
                            self.selectedInboxItem = item
                            self.showActionSheet = true
                        }) {
                            Image(systemName: "ellipsis.circle")
                        }
                        .actionSheet(isPresented: $showActionSheet) {
                             ActionSheet(title: Text("Options"), buttons: [
                                 .default(Text("Add as Actionable Item")) {
                                     self.currentAction = .addToNextActions(self.selectedInboxItem!)
                                     self.inboxItemMovedOut = true
                                 },
                                 .default(Text("Create new project")) {
                                     self.currentAction = .createProject(self.selectedInboxItem!)
                                     self.inboxItemMovedOut = true
                                 },
                                 .default(Text("Add as Reference")) {
                                     self.currentAction = .addAsReference(self.selectedInboxItem!)
                                     self.inboxItemMovedOut = true
                                 },
                                 .destructive(Text("Delete")) {
                                     inboxViewModel.deleteInboxItem(id: self.selectedInboxItem!.id)
                                 },
                                 .cancel()
                             ])
                         }                    }
                }
            }
            .navigationTitle("Inbox")
            .fullScreenCover(item: $currentAction) { action in
                switch action {
                case .createProject(let item):
                    AddProjectView(projectName: item.title)
                        .environmentObject(allProjectsViewModel)
                case .addToNextActions(let item):
                    AddActionView(title: item.title)
                        .environmentObject(nextActionsViewModel)
                        .environmentObject(allProjectsViewModel)
                case .addAsReference(let item):
                    AddReferenceView(title: item.title, viewModel: referencesViewModel)
                }
            }
        
            .onChange(of: inboxItemMovedOut) { value in
                if value {
                    inboxViewModel.deleteInboxItem(id: selectedInboxItem!.id)
                    inboxItemMovedOut = false
                }
            }

        
            .navigationBarItems(trailing: NavigationLink(destination: AddInboxItemView()) {
                Image(systemName: "plus")
            }

            )

    }
}

struct InboxPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            InboxPageView().environmentObject(InboxViewModel())
        }
    }
}
