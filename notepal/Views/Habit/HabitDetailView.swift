//
//  HabitDetailView.swift
//  notepal
//
//  Created by ahmad naufal alfakhar on 14/07/24.
//

import SwiftUI
import EventKit
import EventKitUI

struct HabitDetailView: View {
    
    @State private var showEventEditor = false
    @State private var eventStore = EKEventStore()
    
    @State private var myHabit: String = "My Habit"
    @State private var myGoalsDesc: String = "Tujuan melakukan habit ini untuk ..."
    @State private var myActionPlanDesc: String = "Hal-hal yang harus dilakukan adalah ..."
    @State private var whatINeedDesc: String = "Hal yang diperlukan agar bisa memulai ..."
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    showEventEditor = true
                }
            } else {
                print("Access denied")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                TextField("",text: $myHabit)
                    .font(.largeTitle)
                    .bold()
                
                Button(action: {
                    requestAccessToCalendar()
                }, label: {
                    Text("Add to Calendar")
                })
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("My Goals")
                        .font(.title2)
                        .bold()
                    TextField("",text: $myGoalsDesc)
                }
                
                VStack(alignment: .leading) {
                    Text("My Action Plan")
                        .font(.title2)
                        .bold()
                    TextField("",text: $myActionPlanDesc)
                }
                
                VStack(alignment: .leading) {
                    Text("What I Need")
                        .font(.title2)
                        .bold()
                    TextField("",text: $whatINeedDesc)
                }
                
                Spacer()

            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "checklist")
                    })
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "camera")
                    })
                }
            }
        }
        .sheet(isPresented: $showEventEditor) {
            EventEditView(eventStore: eventStore)
        }
    }
}

struct EventEditView: UIViewControllerRepresentable {
    var eventStore: EKEventStore
    var event: EKEvent = EKEvent(eventStore: EKEventStore())

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        controller.event = event
        controller.editViewDelegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditView

        init(_ parent: EventEditView) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}


#Preview {
    HabitDetailView()
}
