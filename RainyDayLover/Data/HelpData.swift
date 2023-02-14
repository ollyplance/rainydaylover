//
//  HelpData.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 12/12/22.
//

import SwiftUI
class HelpData: ObservableObject {
    
    @Published var entries: [Help] = []
    
    init() {
        setup()
    }
        
    private static func getDataFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("help.data")
    }
    
    func load() {
        do {
            let fileURL = try HelpData.getDataFileURL()
            let data = try Data(contentsOf: fileURL)
            entries = try JSONDecoder().decode([Help].self, from: data)
        } catch {
            print("Failed to load from file. Backup data used")
        }
    }
    
    func save() {
        do {
            let fileURL = try HelpData.getDataFileURL()
            let data = try JSONEncoder().encode(entries)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save")
        }
    }
    
    func setup() {
        do {
            let fileURL = try HelpData.getDataFileURL()
            let data = try Data(contentsOf: fileURL)
            entries = try JSONDecoder().decode([Help].self, from: data)
        } catch {
            save()
        }
    }
}
