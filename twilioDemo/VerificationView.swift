//
//  VerificationView.swift
//  twilioDemo
//
//  Created by Bokai Li on 7/14/21.
//

import SwiftUI

struct VerificationView: View {
    
    @ObservedObject var vm = VerificationVM()
    @State var code = ""
    @State var message = "default"
    @State var phoneNumber=""
    var body: some View {
        VStack{
            TextField("Phone Number", text: $phoneNumber)
                .multilineTextAlignment(.center)
            Button(action: {
                vm.sendVerificationCode("1", phoneNumber)
            }, label: {
                Text("Send Verification")
            })
            TextField("Code", text: $code)
                .multilineTextAlignment(.center)
            Button(action: {
                message=""
                vm.validateVerificationCode("1", phoneNumber, code){
                    checked in
                    if (checked.success) {
                        print("checked.success is true")
                        print(checked.message)
                        message = "success"
                        
                    } else {
                        print("checked.success is false")
                        print(checked.message)
                        message = "failed"
                    }
                }
                
            }, label: {
                Text("Verify")
            })
            Text(message)
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
