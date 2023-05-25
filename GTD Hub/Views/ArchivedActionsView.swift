//
//  ArchivedActionsView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/21/23.
//

import SwiftUI

struct ArchivedActionsView: View {
    @EnvironmentObject var nextActionsViewModel: NextActionsViewModel

    var body: some View {
        List {
            ForEach(nextActionsViewModel.completedActionItems) { actionItem in
                ActionItemView(
                    action: actionItem,
                    actionCompletion: {},
                    color: .green
                )
                .contextMenu {
                    Button(action: {
                        withAnimation {
                            nextActionsViewModel.updateActionCompletionStatus(inputAction: actionItem)
                        }
                    }) {
                        Text("Unmark Complete")
                        Image(systemName: "checkmark.circle")
                    }
                }
            }
            .onDelete(perform: nextActionsViewModel.removeAction)
        }
        .navigationTitle("Archived Actions")
        .navigationBarItems(leading: EditButton(), trailing: Button(action: {
            nextActionsViewModel.removeAllCompletedActions()
        }) {
            Text("Delete All")
        })
    }
}



struct ArchivedActionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchivedActionsView()
        }
        .environmentObject(NextActionsViewModel(coordinator: ProjectActionCoordinator()))
    }
}


