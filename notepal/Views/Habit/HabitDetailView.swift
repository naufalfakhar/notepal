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
        let event = EKEvent(eventStore: eventStore)
        event.title = viewModel.data[0].title
        //        event.notes = "\(myGoalsDesc)\n\n\(myActionPlanDesc)\n\n\(whatINeedDesc)"
        event.url = URL(string: "notepal://page?id=\(viewModel.data.first!.id)")
        event.startDate = Date()
        event.endDate = Date().addingTimeInterval(3600) // 1 hour event
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            print("Event saved")
        } catch let error as NSError {
            print("Failed to save event with error: \(error)")
        }
    }
    
    var body: some View {
        NavigationStack{
            
            if let note = viewModel.data.first{
                VStack(alignment: .leading) {
                    TextField("", text: $viewModel.data[0].title)
                        .font(.largeTitle)
                        .bold()
                    
                    Button(action: {
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
                    
                    ForEach($viewModel.data[0].plans){ $list in
                        Toggle(
                            list.content,
                            isOn: $list.done
                        ).toggleStyle(CheckboxStrikethrough(
                            text: $list.content,
                            axis: .vertical
                        ))
                    }
                    
                    Divider()
                    
                    ForEach($viewModel.data[0].note.contents) { $note in
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
                    EventEditView(eventStore: eventStore, onSave: createCalendarEvent)
                }
            }
            else{
                Text("No Notes with This Id")
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
                        Checklist(content: "Make your action plan"),
                        Checklist(content: "Another plan"),
                    ]
                )
            
                viewModel.addHabit(newHabit: newHabit)
                viewModel.fetchById(id: newHabit.id.uuidString)
            }
        }
        
    }
}

struct EventEditView: UIViewControllerRepresentable {
    var eventStore: EKEventStore
    var event: EKEvent = EKEvent(eventStore: EKEventStore())
    var onSave: () -> Void
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        controller.event = event
        controller.editViewDelegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, onSave: onSave)
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditView
        var onSave: () -> Void
        
        init(_ parent: EventEditView, onSave: @escaping () -> Void) {
            self.parent = parent
            self.onSave = onSave
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true, completion: nil)
            if action != .canceled {
                onSave()
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        HabitDetailView(id: )
//    }
//}
