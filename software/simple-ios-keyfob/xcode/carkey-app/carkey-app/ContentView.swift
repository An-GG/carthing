//
//  ContentView.swift
//  carkey-app
//
//  Created by an on 10/23/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var unlock_disabled = false
    @State var lock_disabled = false
    @State var loading = false

    var body: some View {
        ZStack {
            
            MyUIViewControllerRepresentable()
            
            VStack {
                
                Button { unlock()  } label: { Label("Unlock", systemImage: "lock.open.fill").frame(maxWidth: 130) }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .disabled(self.unlock_disabled)
                    .onTapGesture { disabled_unlock_tapped() }
                
                Button { lock()  } label: {
                    Label("Lock", systemImage: "lock.fill").frame(maxWidth: 130) }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .disabled(self.lock_disabled)
                    .onTapGesture { disabled_lock_tapped() }
                
                Button { read()  } label: {
                    Label("Read", systemImage: "lock.fill").frame(maxWidth: 130) }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)

                
                Group {
                    if loading {
                        ProgressView()
                    } else {
                        ProgressView().hidden()
                    }
                }.padding()
                
            }.padding()
            
            
        }
        
    }
    
    
    
    func lock() {
        lock_disabled = true
        bt_send_lock_command(lock_state_callback: self.lock_state_callback(state:))
        loading = true
    }

    func unlock() {
        unlock_disabled = true
        bt_send_unlock_command(lock_state_callback: self.lock_state_callback(state:))
        loading = true
    }
    
    func read() {
        bt_get_predicted_lock_state(lock_state_callback: self.lock_state_callback(state:))
        loading = true
    }
    
    
    func disabled_lock_tapped() {
        lock()
    }

    func disabled_unlock_tapped() {
        unlock()
    }
    
    func lock_state_callback(state:predicted_lock_state) {
        if (state == .unknown) {
            self.lock_disabled = false
            self.unlock_disabled = false
        }
        if (state == .locked) {
            self.lock_disabled = true
            self.unlock_disabled = false
        }
        if (state == .unlocked) {
            self.unlock_disabled = true
            self.lock_disabled = false
        }
        loading = false
    }
    

}





#Preview {
    ContentView()
}
