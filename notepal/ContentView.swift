//
//  ContentView.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 12/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    Section{
                        NavigationLink{
                            // code here
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
                        }label:{
                            HStack{
                                Image(systemName: "folder")
                                Text("Habit Journey")
                            }
                        }
                    }
                }            
                .listSectionSpacing(.compact)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                   HStack {
                       Text("NotePal")
                           .bold()
                           .font(.largeTitle)
                           .padding(.leading)
                       Spacer()
                   }
               }
            }
        }
    }
}

#Preview {
    ContentView()
}
