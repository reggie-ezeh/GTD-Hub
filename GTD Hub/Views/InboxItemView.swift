//
//  InboxItemView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/18/23.
//

import SwiftUI

struct InboxItemView: View {
    var inboxItem: InboxItem

    var body: some View {
        HStack {
            Text(inboxItem.title)
                .font(.largeTitle)

            Spacer()

            VStack(alignment: .trailing) {
                if let captureDate = inboxItem.captureDate {
                    Text("Captured on : \(formatDate(captureDate))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }


            }
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct InboxItemView_Previews: PreviewProvider {
    static var previews: some View {
        InboxItemView(inboxItem: InboxItem(title: "Inbox test 1", captureDate: Date()))
    }
}

