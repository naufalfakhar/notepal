//
//  ContentView.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 12/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchValue = ""
    
    var body: some View {
        NavigationStack{
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
        }
    }
}

#Preview {
    ContentView()
}
