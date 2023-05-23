//
//  InboxPageView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/19/23.
//

import SwiftUI

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
                                .default(Text("Create new project")) {
                                    self.showCreateProject = true
                                },
                                .default(Text("Add to Project")) {
                                    self.showAddToProject = true
                                },
                                .default(Text("Add to Next Actions")) {
                                    self.showAddToNextActions = true
                                },
                                .default(Text("Add as Reference")) {
                                    self.showAddAsReference = true
                                },
                                .destructive(Text("Delete")) {
                                    inboxViewModel.deleteInboxItem(id: item.id)
                                },
                                .cancel()
                            ])
                        }
                    }
                }
            }
            .navigationTitle("Inbox")
            .fullScreenCover(item: $selectedInboxItem) { selectedItem in
                if self.showCreateProject {
                    AddProjectView(projectName: selectedItem.title)
                        .environmentObject(allProjectsViewModel)
                } else if self.showAddToProject {
                    AddActionView(title: selectedItem.title)
                        .environmentObject(nextActionsViewModel)
                        .environmentObject(allProjectsViewModel)
                } else if self.showAddToNextActions {
                    AddActionView(title: selectedItem.title)
                        .environmentObject(nextActionsViewModel)
                        .environmentObject(allProjectsViewModel)
                } else if self.showAddAsReference {
                    AddReferenceView(title: selectedItem.title, viewModel: referencesViewModel)
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
