//
//  SettingsView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 08/05/24.
//

import SwiftUI

enum iRetroInputMapping: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case returnKey = "Return"
    
    var relatedKey: KeyEquivalent {
        switch self {
        case .returnKey:
            return .return
        }
    }
    
    init(keyEquivalent: KeyEquivalent) {
        switch keyEquivalent {
        case .return:
            self = .returnKey
        default:
            self = .returnKey
        }
    }
}

struct SettingsView: View {
    @State private var configuredKeyIndex = iRetroInputMapping(rawValue: UserDefaults.standard.value(forKey: "Return") as! String)!
        
    var body: some View {
        Form {
            Picker("Configured Key", selection: $configuredKeyIndex) {
                ForEach(iRetroInputMapping.allCases) { index in
                    Text(index.rawValue).tag(index)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
