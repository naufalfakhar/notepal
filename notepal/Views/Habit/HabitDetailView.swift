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
                        
                        TextField(text: $viewModel.data[0].goal){}
                        
                        Text("My Action Plan")
                            .font(.headline)
                        
                        ForEach($viewModel.data[0].plans.sorted(by: {$0.id < $1.id})){ $list in
                            Toggle(
                                list.content,
                                isOn: $list.done
                            ).toggleStyle(CheckboxStrikethrough(
                                //                            id: $list.id,
                                //                            model: $viewModel.data[0],
                                text: $list.content
                            ))
                        }
                        
                        Divider()
                        
                        ForEach($viewModel.data[0].note) { $note in
                            VStack(alignment: .leading) {
                                
                                Text(note.createdAt.noteFormatted())
                                    .font(.headline)
                                
                                TextView(
                                    attributedText: $note.content,
                                    allowsEditingTextAttributes: true,
                                    font: .systemFont(ofSize: 24)
                                )
                                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
                            }
                            .padding(.vertical)
                        }
                    }
                    .padding()
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
                    plan: [
                        Checklist(id: 1, content: "Make your action plan"),
                        Checklist(id: 2, content: "Another Plan"),
                        Checklist(id: 3, content: "Specific Plan"),
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
