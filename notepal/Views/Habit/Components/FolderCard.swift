//
//  FolderCard.swift
//  notes
//
//  Created by Dason Tiovino on 11/07/24.
//

import Foundation
import SwiftUI
import SwiftData

struct FolderCard: View {
    @Binding var model: Folder
    
    @Binding var folderData: [Folder]
    @Binding var data: [Habit]
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        DisclosureGroup(model.title, isExpanded: $isExpanded){
            ForEach(folderData.filter { $0.parentId == model.id }) { subFolder in
                Self(
                    model: .constant(subFolder),
                    folderData: $folderData,
                    data: $data
                )
            }
            
            ForEach(data.filter{$0.folderId == model.id}) { note in
                HabitCard(model: .constant(note))
            }
        }.padding()
    }
}
