//
//  moluccus_iosApp.swift
//  moluccus-ios
//
//  Created by la niina on 4/7/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct moluccus_iosApp: App {
    init() {
           FirebaseApp.configure()
       }

       var body: some Scene {
           WindowGroup {
               ContentStart()
           }
       }
}
