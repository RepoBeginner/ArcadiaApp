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
    @Environment(InputController.self) var inputController: InputController
    
    init(dismissMainView: Binding<Bool>) {
        self._dismissMainView = dismissMainView
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Save states")) {
                    Button(
                        action: {
                            ArcadiaCoreEmulationState.sharedInstance.currentCore?.saveState(saveFileURL: ArcadiaCoreEmulationState.sharedInstance.currentStateURL!)
                            dismiss()
                        }) {
                        Text("Save State")
                    }
                    Button(
                        action: {
                            ArcadiaCoreEmulationState.sharedInstance.currentCore?.loadState(saveFileURL: ArcadiaCoreEmulationState.sharedInstance.currentStateURL!)
                            dismiss()
                        }) {
                        Text("Load State")
                    }
                        .disabled(
                            !FileManager.default.fileExists(atPath: ArcadiaCoreEmulationState.sharedInstance.currentStateURL!.path())
                        )
                }
                
                PlayerSelectionView()
            }
            .padding()
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
            .onAppear {
                inputController.unloadGameConfiguration()
            }
            .onDisappear {
                inputController.loadGameConfiguration()
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

