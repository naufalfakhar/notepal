//
//  CreateHabitView.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 16/07/24.
//

import SwiftUI
import EventKit
import EventKitUI

struct CreateHabitView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var habitVM = HabitViewModel()
    
    @State private var eventStore = EKEventStore()
    @State private var showEventEditor = false
    
    @State private var myHabit: String = "My Habit"
    @State private var myGoal: String = "Tujuan melakukan habit ini untuk ..."
    @State private var myActionPlan: String = "Hal-hal yang harus dilakukan adalah ..."
    @State private var myNeed: String = "Hal yang diperlukan agar bisa memulai ..."
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("", text: $myHabit)
                .font(.largeTitle)
                .bold()
            
            Button(action: {
                requestAccessToCalendar()
            }, label: {
                Text("Add to Calendar")
            })
            
            Divider()
            
            Section {
                Text("My Goals")
                    .font(.headline)
                    .bold()
                TextEditor(text: $myGoal)
                    .padding(.horizontal, -4)
            }
            
            Section {
                Text("My Action Plan")
                    .font(.headline)
                    .bold()
                TextEditor(text: $myActionPlan)
                    .padding(.horizontal, -4)
            }
            
            Section {
                Text("What I Need")
                    .font(.headline)
                    .bold()
                TextEditor(text: $myNeed)
                    .padding(.horizontal, -4)
            }
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    habitVM.addHabit(newHabit: Habit(title: myHabit,
                                                     goal: myGoal))
//                                                     plan: myActionPlan,
//                                                     need: myNeed))
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                })
            }
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
        .onAppear {
            habitVM.modelContext = modelContext
        }
    }
    
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
        event.title = habitVM.data[0].title
        event.notes = "\(myGoal)\n\n\(myActionPlan)\n\n\(myNeed)"
        event.url = URL(string: "notepal://page?id=\(habitVM.data.first!.id)")
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
}

#Preview {
    NavigationStack {
        CreateHabitView()
            .modelContainer(for: [
                Folder.self,
                Habit.self,
            ])
    }
}

