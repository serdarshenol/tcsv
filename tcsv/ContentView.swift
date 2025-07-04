//
//  ContentView.swift
//  tcsv
//
//  Created by Serdar Senol on 04/07/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var groupName = ""
    @State private var userName = ""
    @State private var email = ""

    @State private var entries: [UserEntry] = []
    @State private var importedEntries: [UserEntry] = []

    @State private var showExporter = false
    @State private var exportURL: URL?

    @State private var showImporter = false
    @State private var showResetAlert = false

    var body: some View {
        NavigationView {
            Form {
                // MARK: Add Entry Section
                Section(header: Text("Add Entry")) {
                    TextField("Group Name", text: $groupName)
                    TextField("User Name / Surname", text: $userName)
                    TextField("Email", text: $email)

                    Button("Add Entry") {
                        let entry = UserEntry(group: groupName, name: userName, email: email)
                        entries.append(entry)
                        groupName = ""
                        userName = ""
                        email = ""
                    }
                    .disabled(groupName.isEmpty || userName.isEmpty || email.isEmpty)
                }

                // MARK: Editable Entries Section
                Section(header: Text("Entries")) {
                    if entries.isEmpty {
                        Text("No entries added.")
                    } else {
                        ForEach($entries) { $entry in
                            VStack(alignment: .leading) {
                                TextField("Group", text: $entry.group)
                                TextField("Name", text: $entry.name)
                                TextField("Email", text: $entry.email)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                // MARK: Export / Reset Section
                if !entries.isEmpty {
                    Section {
                        Button("Export Locked CSV") {
                            if let url = FileHelper.exportLockedCSV(entries: entries) {
                                exportURL = url
                                showExporter = true
                            }
                        }
                        .fileExporter(
                            isPresented: $showExporter,
                            document: exportURL.map { CSVDocument(fileURL: $0) },
                            contentType: .data,
                            defaultFilename: "locked_data.lcsv"
                        ) { _ in }

                        Button("Reset Entries") {
                            showResetAlert = true
                        }
                        .foregroundColor(.red)
                        .alert("Clear All Entries?", isPresented: $showResetAlert) {
                            Button("Reset All", role: .destructive) {
                                entries.removeAll()
                                importedEntries.removeAll()
                            }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("This will remove all added and imported entries. Are you sure?")
                        }
                    }
                }

                // MARK: Import Section
                Section {
                    Button("Import and View Locked CSV") {
                        showImporter = true
                    }
                    .fileImporter(isPresented: $showImporter, allowedContentTypes: [.data], allowsMultipleSelection: false) { result in
                        if let selectedFile = try? result.get().first,
                           let decoded = FileHelper.readLockedCSV(from: selectedFile) {
                            importedEntries = decoded
                            
                            // Filter out duplicates
                            let newEntries = decoded.filter { !entries.contains($0) }

                            if !newEntries.isEmpty {
                                entries.append(contentsOf: newEntries)
                            }
                        }
                    }
                }

                // MARK: Imported Entries Display
                if !importedEntries.isEmpty {
                    Section(header: Text("Imported Entries")) {
                        ForEach(importedEntries) { entry in
                            VStack(alignment: .leading) {
                                Text("Group: \(entry.group)")
                                Text("Name: \(entry.name)")
                                Text("Email: \(entry.email)")
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Locked CSV App")
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
