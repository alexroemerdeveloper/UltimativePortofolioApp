//
//  EditProjectView.swift
//  UltimativePortofolioApp
//
//  Created by Alexander Römer on 30.10.20.
//

import SwiftUI
import CoreHaptics
import CloudKit

struct EditProjectView: View {
    
    enum CloudStatus {
        case checking, exists, absent
    }
    
    @State private var cloudStatus = CloudStatus.checking

    @EnvironmentObject var dataController: DataController
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteConfirm = false
    
    @ObservedObject var project: Project
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    
    @State private var engine = try? CHHapticEngine()
    
    @State private var remindMe: Bool
    @State private var reminderTime: Date
    
    @State private var showingNotificationsError = false
    
    @AppStorage("username") var username: String?
    @State private var showingSignIn = false
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(project: Project) {
        self.project = project
        _title  = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color  = State(wrappedValue: project.projectColor)
        
        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(wrappedValue: projectReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
    }
    
    var body: some View {
        Form {
            // section 1
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            
            // section 2
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }
            
            Section(header: Text("Project reminders")) {
               Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
                .alert(isPresented: $showingNotificationsError) {
                    Alert(
                        title: Text("Oops!"),
                        message: Text("There was a problem. Please check you have notifications enabled."),
                        primaryButton: .default(Text("Check Settings"), action: showAppSettings),
                        secondaryButton: .cancel()
                    )
                }

               if remindMe {
                   DatePicker(
                       "Reminder time",
                       selection: $reminderTime.onChange(update),
                       displayedComponents: .hourAndMinute
                   )
               }
           }
    
            
            // section 3
            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.")) {
                
                Button(project.closed ? "Reopen this project" : "Close this project", action: toggleClosed)
                
                Button("Delete this project") {
                    // delete the project
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
            
        }
        .navigationTitle("Edit Project")
        .toolbar {
            switch cloudStatus {
            case .checking:
                ProgressView()
            case .exists:
                Button(action: removeFromCloud) {
                    Label("Remove from iCloud", systemImage: "icloud.slash")
                }
            case .absent:
                Button(action: uploadToCloud) {
                    Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
                }
            }
        }
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(title: Text("Delete project?"),
                  message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), // swiftlint:disable:this line_length
                  primaryButton: .default(Text("Delete"),
                  action: delete), secondaryButton: .cancel())
        }
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
        .onAppear(perform: updateCloudStatus)

    }
    
    func toggleClosed() {
        
        project.closed.toggle()
        update()
        
        if project.closed {
            // trigger haptics
            
            do {
                try engine?.start()
                
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                
                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
                
                let parameter = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )
                
                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )
                
                // create a continuous haptic event starting immediately and lasting one second
                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intensity],
                    relativeTime: 0.125,
                    duration: 1
                )
                
                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
                
            } catch {
                print("Haptic not working to play  ")
            }
        }
    }
    
    func updateCloudStatus() {
        project.checkCloudStatus { exists in
            if exists {
                cloudStatus = .exists
            } else {
                cloudStatus = .absent
            }
        }
    }
    
    func removeFromCloud() {
        let name = project.objectID.uriRepresentation().absoluteString
        let id = CKRecord.ID(recordName: name)

        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])

        operation.modifyRecordsCompletionBlock = { _, _, _ in
            updateCloudStatus()
        }

        cloudStatus = .checking
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func update() {
        project.title  = title
        project.detail = detail
        project.color  = color
        
        if remindMe {
            project.reminderTime = reminderTime

            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false
                    showingNotificationsError = true
                }
            }
        } else {
            project.reminderTime = nil
            dataController.removeReminders(for: project)
        }

    }
    
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
    
    func colorButton(for item: String) -> some View {
        // paste your code here
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)
            
            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityHint(LocalizedStringKey(item))
    }
    
    func showAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    func uploadToCloud() {
        if let username = username {
            let records = project.prepareCloudRecords(owner: username)
            let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            operation.savePolicy = .allKeys

            operation.modifyRecordsCompletionBlock = { _, _, error in
                updateCloudStatus()
            }

            cloudStatus = .checking

            CKContainer.default().publicCloudDatabase.add(operation)
        } else {
            showingSignIn = true
        }
    }

    
    
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
