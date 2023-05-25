//
//  HomePageView.swift
//  GTD Hub
//
//  Created by Reggie Ezeh on 5/19/23.
//

import SwiftUI

struct HomePageView: View {
    @State private var showAddPopup = false
    @State private var navigateTo: AddViews?
    
    @EnvironmentObject var nextActionsViewModel: NextActionsViewModel
    @EnvironmentObject var allProjectsViewModel: AllProjectsViewModel
    @EnvironmentObject var referencesViewModel: ReferencesViewModel
    @EnvironmentObject var inboxViewModel: InboxViewModel

    var body: some View {
            VStack {
                VStack(spacing: 20) {
                    Spacer()
                    Text("GTD HUB")
                        .font(.system(size: 50, weight: .bold, design: .default))

                        .foregroundColor(Color(hue: 0.492, saturation: 0.871, brightness: 0.497))
                    Spacer()
                    
                    NavigationLink(destination: InboxPageView()) {
                        Text("Inbox")
                            .font(.title)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .frame(width: 200.0, height: 70.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: NextActionsView()) {
                        Text("Next Actions")
                            .font(.title)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .frame(width: 200.0, height: 70.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: ActiveProjectsListView()) {
                        Text("Projects")
                            .font(.title)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .frame(width: 200.0, height: 70.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: ReferencesView()) {
                        Text("References")
                            .font(.title)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .frame(width: 200.0, height: 70.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Button(action: { showAddPopup.toggle() }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                }
                .padding()
                .actionSheet(isPresented: $showAddPopup) {
                    ActionSheet(title: Text("Create New"), buttons: [
                        .default(Text("Inbox Item")) { navigateTo = .addInboxItem },
                        .default(Text("Next Action")) { navigateTo = .addAction },
                        .default(Text("Project")) { navigateTo = .addProject },
                        .default(Text("Reference")) { navigateTo = .addReference },
                        .cancel()
                    ])
                }
            }
            .navigationTitle("Home")
            .sheet(item: $navigateTo, content: { destination in
                switch destination {
                case .addInboxItem:
                    AddInboxItemView().environmentObject(inboxViewModel)
                case .addAction:
                    AddActionView().environmentObject(nextActionsViewModel).environmentObject(allProjectsViewModel)
                case .addProject:
                    AddProjectView().environmentObject(allProjectsViewModel)
                case .addReference:
                    AddReferenceView(viewModel: referencesViewModel)
                }
            })
    }

    private enum AddViews: Identifiable {
        case addInboxItem, addAction, addProject, addReference

        var id: Int {
            switch self {
            case .addInboxItem:
                return 0
            case .addAction:
                return 1
            case .addProject:
                return 2
            case .addReference:
                return 3
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomePageView()
        }
    }
}
