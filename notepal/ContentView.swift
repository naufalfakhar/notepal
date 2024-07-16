//
//  ContentView.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 12/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchValue = ""
//    @EnvironmentObject var navigationViewModel: NavigationViewModel

    var body: some View {
        NavigationStack{
//            switch navigationViewModel.currentDestination {
//            case .home:
                List{
                    Section{
                        NavigationLink{
                            // TODO: Navigate to Regular Notes
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
                                .navigationBarTitleDisplayMode(.inline)
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
                .searchable(text: $searchValue, prompt: "Search")
                
//                case .detail(let data):
//                    HabitDetailView(id: data)
//            }
//        }.onOpenURL{ url in
//            guard url.scheme == "mynotes" else {return}
//            
//            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
//                var newParams: [String: String] = [:]
//                for queryItem in queryItems {
//                    newParams[queryItem.name] = queryItem.value
//                }
//                
//                navigationViewModel.navigateToDetail(with: newParams["id"] ?? "")
//            }
        }
    }
}

#Preview {
    ContentView()
//        .environmentObject(NavigationViewModel())
}
