//
//  ReferenceItemView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/18/23.
//

import SwiftUI

struct ReferenceItemView: View {
    let item: ReferenceItem

    var body: some View {
        Text(item.title)
    }
}

struct ReferenceItemView_Previews: PreviewProvider {
    static var previews: some View {
        ReferenceItemView(item: ReferenceItem(title: "Sample Reference"))
    }
}
