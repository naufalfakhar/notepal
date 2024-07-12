//
//  RepeatNoteDialog.swift
//  notes
//
//  Created by Dason Tiovino on 11/07/24.
//

import Foundation
import SwiftUI
import SwiftData

struct RepeatNoteView: View {
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            
            VStack(alignment: .leading){
                Text("Repeat")
                Button{
                    // code
                }label: {
                    Image(systemName: "")
                    Text("Daily")   
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay{
                VStack{
                    HStack{
                        Spacer()
                        Button{
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.medium)
                        }.tint(.black)
                    }
                    
                    Spacer()
                }.padding()
            }
            .padding()
        }.ignoresSafeArea()
    }
    
    func close(){
        isActive = false
    }
}

