//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Andrew CP Markham on 16/11/20.
//

import SwiftUI
import CoreHaptics
import CloudKit

// swiftlint:disable:next type_body_length
struct EditProjectView: View {
    enum CloudStatus {
        case checking, exists, absent
    }

    @ObservedObject var project: Project
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingDeleteConfirm = false
    @State private var engine = try? CHHapticEngine()
    @State private var remindMe: Bool
    @State private var reminderTime: Date
    @State private var showingNotificationsError = false
    @AppStorage("username") var username: String?
    @State private var showingSignIn = false
    @State private var cloudStatus = CloudStatus.checking
    @State private var cloudError: CloudError?

    let colorColumns = [GridItem(.adaptive(minimum: 44))
    ]
    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)

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
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton )
                }
                .padding(.vertical)
            }
            Section(header: Text("Project reminders")) {
                Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
                    .alert("Oops", isPresented: $showingNotificationsError ) {
                        #if os(iOS)
                        Button("Check Settings", action: showAppSettings)
                        #endif
                        Button("OK") { }
                    } message: {
                        Text("There was a problem. Please check you have notifications enabled")
                    }

                if remindMe {
                    DatePicker(
                        "Reminder Time",
                        selection: $reminderTime.onChange(update),
                        displayedComponents: .hourAndMinute
                    )
                }
            }
            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.")) {
                Button(project.closed ? "Reopen this project" : "Close this project", action: toggleClosed)
                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
                .alert(isPresented: $showingDeleteConfirm) {
                    Alert(
                        title: Text("Delete project"),
                        message: Text("Are you sure you want to delete this project? You will also delete all the items if contains."), // swiftlint:disable:this line_length
                        primaryButton: .default(Text("Delete"),
                                                action: delete),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationTitle("Edit Project")
        .toolbar {
            switch cloudStatus {
            case .checking:
                ProgressView()
            case .exists:
                Button {
                        removeFromCloud(deleteLocal: false)
                } label: {
                    Label("Remove to iCloud", systemImage: "icloud.slash")
                }
            case .absent:
                Button(action: uploadToCloud) {
                    Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
                }
            }
        }
        .onAppear(perform: updateCloudStatus)
        .onDisappear(perform: dataController.save)
        .alert(item: $cloudError) { error in
            Alert(
                title: Text("There was an error"),
                message: Text(error.localisedMessage)
            )
        }
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color

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
    func toggleClosed() {
        project.closed.toggle()
        if project.closed {
            // haptics to enhance the UX of clossing a project

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

                // Quick tap immediatetly
                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )
                // continuous receeding event for 1 second
                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intensity],
                    relativeTime: 0.125,
                    duration: 1
                )

                let pattern = try CHHapticPattern(
                    events: [event1, event2],
                    parameterCurves: [parameter]
                )

                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                // Haptics didnt work but not a biggie
            }
        }
    }

    /// local copy delete request
    func delete() {
        if cloudStatus == .exists {
            removeFromCloud(deleteLocal: true)
        } else {
            dataController.delete(project)
            presentationMode.wrappedValue.dismiss()
        }
    }

    func colorButton(for item: String) -> some View {
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

    #if os(iOS)
    func showAppSettings() {
        /// Function to present user with the app setting specifically for notification enabling
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    #endif

    func uploadToCloud() {
        if let username = username {
            let records = project.prepareCloudRecords(owner: username)
            let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            operation.savePolicy = .allKeys

            // Code for < IOS 15
//            operation.modifyRecordsCompletionBlock = { _, _, error in
//                if let error = error {
//                    cloudError = error.getCloudKitError()
//                }
//                updateCloudStatus()
//            }

            // Opperation result
            operation.modifyRecordsResultBlock = { result in
                switch result {
                case .success:
                    print( "Network Success")
                case .failure(let error):
                    cloudError = CloudError(error: error)
                }
            }

            // Data upload result
            operation.modifyRecordsResultBlock = { result in
                switch result {
                case .success:
                    print("Upload Success")
                case .failure(let error):
                    cloudError = CloudError(error: error)
                }
                updateCloudStatus()
            }

            cloudStatus = .checking
            CKContainer.default().publicCloudDatabase.add(operation)
        } else {
            showingSignIn = true
        }
    }

    func removeFromCloud(deleteLocal: Bool) {
        /// iCloud delete request
        let name = project.objectID.uriRepresentation().absoluteString
        let id = CKRecord.ID(recordName: name)

        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])

        // Code for < IOS 15
//        operation.modifyRecordsCompletionBlock = { _, _, error in
//        if let error = error {
//            cloudError = error.getCloudKitError()
//        }
//            updateCloudStatus()
//        }

        // Network result
        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                print( "Network Success")
            case .failure(let error):
                cloudError = CloudError(error: error)
            }
        }

        // Opperation result
        operation.modifyRecordsResultBlock = { result in
            print("This refuses to be called")
            switch result {
            case .success:
                if deleteLocal {
                    dataController.delete(project)
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            case .failure:
                print("Error: Unable to delete project form Cloud")
            }
            updateCloudStatus()
        }
        cloudStatus = .checking
        CKContainer.default().publicCloudDatabase.add(operation)

    }

    func updateCloudStatus() {
        /// Check the existance of record in iCloudf and update the status
        project.checkCloudStatus { exists in
            if exists {
                cloudStatus = .exists
            } else {
                cloudStatus = .absent
            }
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
