//
//  ContentView.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 12/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchValue = ""
    @EnvironmentObject var navigationViewModel: NavigationViewModel

    var body: some View {
        NavigationStack{
            switch navigationViewModel.currentDestination {
            case .home:
                List{
                    Section{
                        NavigationLink{
                        RegularNoteView()
                                .toolbarRole(.editor)
                        }label:{
                            HStack{
                                Image(systemName: "folder")
                                Text("Regular Notes")
                            }
                        }
                    }
                    
                    Section{
                        NavigationLink{
                            HabitView()
                                .toolbarRole(.editor)
                        }label:{
                            HStack{
                                Image(systemName: "folder")
                                Text("Habit Journey")
                            }
                        }
                    }
                }
                .listSectionSpacing(.compact)
                .navigationTitle("NotePal")
                .searchable(text: $searchValue, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")

                case .detail(let data):
                    HabitDetailView(id: data)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarLeading) {
                            Button(action: {
                                navigationViewModel.navigateToHome()
                            }, label: {
                                Image(systemName: "chevron.backward")
                            })
                        }

                    }
                    
                
                case .chart:
                    LineChartDetailView()
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarLeading) {
                            Button(action: {
                                navigationViewModel.navigateToHome()
                            }, label: {
                                Image(systemName: "chevron.backward")
                            })
                        }

                    }
            }
        }.onOpenURL{ url in
            guard url.scheme == "notepal" else {return}
            
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                var newParams: [String: String] = [:]
                for queryItem in queryItems {
                    newParams[queryItem.name] = queryItem.value
                }
                
                if(newParams["page"] == "chart"){
                    return navigationViewModel.navigateToChart()
                }
                return navigationViewModel.navigateToDetail(with: newParams["id"] ?? "")
            }
        }
    }
}

#Preview {
    ContentView()
}
