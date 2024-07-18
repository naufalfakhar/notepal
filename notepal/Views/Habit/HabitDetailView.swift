//
//  HabitDetailView.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 14/07/24.
//

import SwiftUI
import EventKit
import EventKitUI

extension Date{
    func noteFormatted() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}

struct HabitDetailView: View {
    var id: String?
    var folderId: String?
    
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel = HabitViewModel()
    
    @State private var showEventEditor = false

    @State private var selectedEvent: EKEvent?
    @State private var eventStore = EKEventStore()
    @FocusState private var amountIsFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    func requestAccessToCalendar() {
        eventStore.requestFullAccessToEvents { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    showEventEditor = true
                }
            } else {
                print("Access denied")
            }
        }
    }
    
    func createCalendarEvent() {
        let event = EKEvent(
            habit: viewModel.data[0],
            url: URL(string: "notepal://page?id=\(viewModel.data.first!.id)")!,
            eventStore: eventStore,
            calendar: eventStore.defaultCalendarForNewEvents,
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600)
        )
        
        selectedEvent = event
    }
    
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                if viewModel.data.first != nil {
                    VStack(alignment: .leading) {
                        TextField("", text: $viewModel.data[0].title)
                            .focused($amountIsFocused)
                            .font(.largeTitle)
                            .bold()
                        
                        Button(action: {
                            createCalendarEvent()
                            requestAccessToCalendar()
                        }, label: {
                            Text("Add to Calendar")
                        })
                        
                        Divider()
                        
                        Text("My Goals")
                            .font(.headline)
                        
                        TextField(text: $viewModel.data[0].goal)
                        {}
                            .focused($amountIsFocused)
            

                        
                        Text("My Action Plan")
                            .font(.headline)
                        
//                        ForEach($viewModel.data[0].needs.sorted(by: {$0.id < $1.id})){ $list in
//                            Toggle(
//                                list.content,
//                                isOn: $list.done
//                            ).toggleStyle(CheckboxStrikethrough(
//                                //                            id: $list.id,
//                                //                            model: $viewModel.data[0],
//                                text: $list.content
//                            ))
//                        }.focused($amountIsFocused)
                        ForEach($viewModel.data[0].plans.sorted(by: {$0.id < $1.id})){ $list in
                            HStack(alignment: .top){
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 8))
                                    .frame(
                                        width: 20,
                                        height: 20,
                                        alignment: Alignment(
                                            horizontal: .center,
                                            vertical: .center)
                                    )
                                TextField(text: $list.content, axis: Axis.vertical){}
                                    .focused($amountIsFocused)
                             }
                        }.focused($amountIsFocused)
                        
                        
                        Text("My Needs")
                            .font(.headline)
                        
                        ForEach($viewModel.data[0].needs.sorted(by: {$0.id < $1.id})){ $list in
                            HStack(alignment: .top){
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 8))
                                    .frame(
                                        width: 20,
                                        height: 20,
                                        alignment: Alignment(
                                            horizontal: .center,
                                            vertical: .center)
                                    )
                                TextField(text: $list.content, axis: Axis.vertical){}                                    .focused($amountIsFocused)
                             }
                        }.focused($amountIsFocused)
                        
                        Divider()
                        
                        ForEach($viewModel.data[0].note) { $note in
                            VStack(alignment: .leading) {
                                
                                Text(note.createdAt.noteFormatted())
                                    .font(.headline)
                                
                                TextView(
                                    attributedText: $note.content,
                                    allowsEditingTextAttributes: true,
                                    font: .systemFont(ofSize: 18)
                                )
                                .focused($amountIsFocused)
                                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding()
                    .toolbar      { if amountIsFocused{
                        Button("Done"){
                            amountIsFocused = false
                        }
                    }
                    }

                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button(action: {
                                // TODO: Action here
                            }, label: {
                                Image(systemName: "textformat")
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                // TODO: Action here
                            }, label: {
                                Image(systemName: "checklist")
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                // TODO: Action here
                            }, label: {
                                Image(systemName: "camera")
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                // TODO: Action here
                            }, label: {
                                Image(systemName: "pencil.tip.crop.circle")
                            })
                            
                        }
                    }
                    .sheet(isPresented: $showEventEditor) {
                        EventEditViewController(event: $selectedEvent, eventStore: eventStore)
                    }
                }
                else{
                    Text("No Notes with This Id")
                }
            }
        }.onAppear{
            viewModel.modelContext = modelContext
            if id != nil {
                viewModel.fetchById(id: id!)
            }else{
                let newHabit = Habit(
                    folderId: folderId != nil ? UUID(uuidString: folderId!) : nil,
                    title: "New Title",
                    goal: "Do what you believe",
                    plans: [
                        DottedList(content: "Make your action plan"),
                        DottedList(content: "Another Plan"),
                        DottedList(content: "Specific Plan"),
                    ],
                    needs: [
                        DottedList(content: "What do you need to accomplish this habit?"),
                        DottedList(content: "What do you need to accomplish this habit?"),
                        DottedList(content: "What do you need to accomplish this habit?"),
                    ],
                    note: [
                        NoteLog()
                    ]
                )
            
                viewModel.addHabit(newHabit: newHabit)
                viewModel.fetchById(id: newHabit.id.uuidString)
            }
        }
        
    }
}
