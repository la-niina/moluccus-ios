//
//  ContentStart.swift
//  moluccus-ios
//
//  Created by la niina on 4/7/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct ContentStart: View {
     @State private var email = ""
     @State private var password = ""
     @State private var showPassword = false
     @State private var loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
     @State private var showError = false
     @State private var errorMessage = ""

     var body: some View {
         if loggedIn {
             // User is logged in, show the main app UI
             ContentView()
         } else {
             // User is not logged in, show the login screen
             VStack {
                 TextField("Email", text: $email)
                     .padding()
                     .autocapitalization(.none)
                     .keyboardType(.emailAddress)
                     .overlay(
                         RoundedRectangle(cornerRadius: 8)
                             .stroke(Color.blue, lineWidth: 1)
                     )
                     .padding(.horizontal, 20)
                     .padding(.vertical, 10)
                     .padding(.bottom, 5)
                     .padding(.vertical, 5)

                 HStack {
                     if showPassword {
                         TextField("Password", text: $password)
                             .padding()
                             .autocapitalization(.none)
                     } else {
                         SecureField("Password", text: $password)
                             .padding()
                     }
                     Button(action: {
                         showPassword.toggle()
                     }, label: {
                         Image(systemName: showPassword ? "eye.slash" : "eye")
                             .foregroundColor(Color.blue)
                             .padding(2)
                     })
                 }
                 .overlay(
                     RoundedRectangle(cornerRadius: 8)
                         .stroke(Color.blue, lineWidth: 1)
                 )
                 .padding(.horizontal, 20)
                 .padding(.vertical, 10)
                 .padding(.bottom, 5)
                 .padding(.vertical, 5)

                 Button(action: {
                     if email.isEmpty || password.isEmpty {
                         errorMessage = "Email and password cannot be empty"
                         showError = true
                     } else {
                         Auth.auth().signIn(withEmail: email, password: password) { result, error in
                             if let error = error {
                                 // An error occurred, handle it appropriately
                                 print("Error logging in: \(error.localizedDescription)")
                                 errorMessage = error.localizedDescription
                                 showError = true
                             } else {
                                 // User is logged in, update UI accordingly
                                 loggedIn = true
                                 UserDefaults.standard.set(loggedIn, forKey: "loggedIn") // Store login status in User Defaults
                             }
                         }
                     }
                 }, label: {
                     Text("Log In")
                         .font(.title2)
                         .fontWeight(.semibold)
                         .foregroundColor(.white)
                         .frame(maxWidth: .infinity, minHeight: 50)
                         .background(Color.blue)
                         .cornerRadius(8)
                         .padding(.horizontal, 20)
                         .padding(.top, 20)
                 })

                 HStack {
                     Spacer()
                     Button(action: {
                         // Handle forgot password action
                     }, label: {
                         Text("Forgot Password?")
                             .foregroundColor(Color.blue)
                             .padding(8)
                     })
                 }
                 .padding(.top, 8)

                   HStack {
                       Spacer()
                       Button(action: {
                           // Handle create account action
                       }, label: {
                           Text("Create Account")
                               .foregroundColor(Color.blue)
                               .padding(8)
                       })
                   }
                   .padding(.top, 8)
               }
               .alert(isPresented: $showError) {
                   Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
               }
           }
       }
   }
