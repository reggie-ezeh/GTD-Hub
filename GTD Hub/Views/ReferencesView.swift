//
//  ReferencesView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/18/23.
//

import SwiftUI

struct ReferencesView: View {
    @EnvironmentObject var referencesViewModel: ReferencesViewModel

    var body: some View {

            List {
                ForEach(referencesViewModel.allReferenceItems) { item in
                    ReferenceItemView(item: item)
                }
            }
            .navigationTitle("References")
            .navigationBarItems(trailing: NavigationLink(destination: AddReferenceView(viewModel: referencesViewModel)) {
                Image(systemName: "plus")
            }
            )

        }
}



struct ReferencesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ReferencesViewModel()
        viewModel.addReferenceItem(title: "Sample Reference 1")
        viewModel.addReferenceItem(title: "Sample Reference 2")
        return     NavigationView {ReferencesView().environmentObject(viewModel)}
    }
}

