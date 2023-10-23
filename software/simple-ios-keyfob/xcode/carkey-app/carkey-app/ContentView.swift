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

    var body: some View {
        VStack {
            
            Button { unlock()  } label: { Label("Unlock", systemImage: "lock.open.fill").frame(maxWidth: 130) }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .disabled(self.unlock_disabled)
                .onTapGesture { disabled_unlock_tapped() }
            
            Button { lock()  } label: { Label("Lock", systemImage: "lock.fill").frame(maxWidth: 130) }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .disabled(self.lock_disabled)
                .onTapGesture { disabled_lock_tapped() }
            
        }.padding()
    }
    
    
    
    func lock() {
        print("lock")
        self.lock_disabled = true
        self.unlock_disabled = false
    }

    func unlock() {
        print("unlock")
        self.unlock_disabled = true
        self.lock_disabled = false
    }
    
    
    func disabled_lock_tapped() {
        print("disabled_lock_tapped")
    }

    func disabled_unlock_tapped() {
        print("disabled_unlock_tapped")
    }

}





#Preview {
    ContentView()
}
