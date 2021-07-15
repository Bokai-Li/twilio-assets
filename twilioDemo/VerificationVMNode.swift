//
//  VerificationVMNode.swift
//  twilioDemo
//
//  Created by Bokai Li on 7/14/21.
//

//work with twilio nodejs backend
//also changed query parameter to body
//import Foundation
//
//enum VerifyError: Error {
//    case invalidUrl
//    case err(String)
//}
//
//protocol WithMessage {
//    var message: String { get }
//}
//
//enum VerifyResult {
//    case success
//    case failure(Error)
//}
//
//
//class DataResult: WithMessage {
//    let data: Data
//    let message: String
//
//    init(data: Data) {
//        self.data = data
//        self.message = String(describing: data)
//    }
//}
//
//struct CheckResult: Codable {
//    let valid: Bool
//}
//
//class VerificationVM: ObservableObject {
//    let path:String?
//    let config:NSDictionary?
//    let baseURLString:String
//
//    init() {
//        self.path = Bundle.main.path(forResource: "Config", ofType: "plist")
//        self.config = NSDictionary(contentsOfFile: path!)
//        self.baseURLString = config!["serverUrl"] as! String
//    }
//
//    func createRequest(_ path: String,
//                       _ parameters: [String: String],
//                       completionHandler: @escaping (_ result: Data) -> VerifyResult) {
//
//        let urlPath = "\(baseURLString)/\(path)"
//        let components = URLComponents(string: urlPath)!
//
//
//        let url = components.url!
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let body = try? JSONSerialization.data(withJSONObject: parameters)
//        request.httpBody = body
//        let session: URLSession = {
//            let config = URLSessionConfiguration.default
//            return URLSession(configuration: config)
//        }()
//
//        let task = session.dataTask(with: request) {
//            (data, response, error) -> Void in
//            if let jsonData = data {
//                let result = completionHandler(jsonData)
//                print(result)
//            } else {
//                // error, no data returned
//            }
//        }
//        task.resume()
//    }
//
//    func sendVerificationCode(_ countryCode: String, _ phoneNumber: String) {
//        let parameters = [
//            "via": "sms",
//            "countryCode": countryCode,
//            "phoneNumber": phoneNumber
//        ]
//
//        createRequest("start", parameters) {
//            json in
//            return .success
//        }
//    }
//
//    func validateVerificationCode(_ countryCode: String, _ phoneNumber: String, _ code: String, completionHandler: @escaping (CheckResult) -> Void) {
//
//        let parameters = [
//            "via": "sms",
//            "countryCode": countryCode,
//            "phoneNumber": phoneNumber,
//            "verificationCode": code
//        ]
//
//        createRequest("check", parameters) {
//            jsonData in
//            let decoder = JSONDecoder()
//            do {
//                let checked = try decoder.decode(CheckResult.self, from: jsonData)
//                DispatchQueue.main.async(execute: {
//                    completionHandler(checked)
//                })
//                return VerifyResult.success
//            } catch {
//                return VerifyResult.failure(VerifyError.err("failed to deserialize"))
//            }
//        }
//    }
//
//}

