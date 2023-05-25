//
//  CircularProgressBar.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/25/23.
//

import SwiftUI

struct CircularProgressBar: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(.gray)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(progress: 20.0)
    }
}
