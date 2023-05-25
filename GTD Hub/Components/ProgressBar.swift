//
//  ProgressBar.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/24/23.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemGray4))
                Rectangle()
                    .frame(width: CGFloat(self.progress)*geometry.size.width, height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
            }
            .cornerRadius(45.0)
        }
    }
}


struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 30.0)
    }
}
