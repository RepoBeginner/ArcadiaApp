//
//  OverlayView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 25/05/24.
//

import SwiftUI
import ArcadiaCore

struct OverlayView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentSelection: String = ""
    @Binding var dismissMainView: Bool

    
    init(dismissMainView: Binding<Bool>) {
        self._dismissMainView = dismissMainView
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Core options")) {
                    List {
                        ForEach(ArcadiaCoreEmulationState.sharedInstance.currentCoreOptions, id: \.self) { option in
                            HStack {
                                Text(option.key)
                                Text(option.description)
                            }
                        }
                    }
                }
            }
            .font(.title)
            .padding()
            .background(.black)
            .navigationTitle("Overlay")
            .toolbar() {
                ToolbarItem(placement: .automatic) {
                    Button(role: .cancel, action: {
                        dismiss()
                    }, label: {
                        Label("Dismiss", systemImage: "xmark")
                    })
                }
               
            }
            .onDisappear {
                ArcadiaCoreEmulationState.sharedInstance.resumeEmulation()
            }
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}


#Preview {
    OverlayView(dismissMainView: .constant(false))
}

