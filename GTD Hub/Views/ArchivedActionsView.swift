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
                ActionItemView(actionItem: actionItem)
            }
        }
        .navigationTitle("Archived Actions")
        .navigationBarItems(trailing: EditButton())
    }
}


struct ArchivedActionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchivedActionsView()
        }
        .environmentObject(NextActionsViewModel())
    }
}
