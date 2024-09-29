//
//  ArcadiaGameBoyCoreInfoVieew.swift
//  Altea
//
//  Created by Davide Andreoli on 29/09/24.
//

import SwiftUI

struct ArcadiaGameBoyCoreInfoView: View {
    
    var body: some View {
        Section(header: Text("BIOS")) {
            Text("This core can optionally use BIOS files. When the BIOS files are used the games will play as in original hardware, which will increase precision but also lock invalid roms. BIOS files can be placed in the core files folder.")
            
        }
    }
}

#Preview {
    List {
        ArcadiaGameBoyCoreInfoView()
    }
}
