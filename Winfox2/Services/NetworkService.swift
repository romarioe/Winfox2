//
//  NetworkService.swift
//  Winfox2
//
//  Created by Roman Efimov on 21.10.2021.
//

import Foundation
import UIKit


class NetworkService{
    
    let baseURL = URL(string: "http://94.127.67.113:8099/")!
    
    
    func registerUser(firstname: String, lastname: String, email: String, password: String, completion: @escaping (UserModel?, _ responseMessage: String?) -> Void){
      let registerURL = baseURL.appendingPathComponent("registerUser")
       
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["email": email,
                    "firstname": firstname,
                    "lastname": lastname,
                    "password": password]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let data = data else {
                    let response = response as! HTTPURLResponse
                    let description = response.description
                    completion(nil, description)
                return
            }
            let jsonDecoder = JSONDecoder()
            let userModel = try? jsonDecoder.decode(UserModel.self, from: data)
            
            

            completion(userModel, nil)
            
            
        }
        task.resume()
    }
    
    
    
    
    func checkLogin(email: String, password: String, completion: @escaping (AuthModel?, _ responseCode: Int?, _ responseMessage: String?) -> Void){
      let loginURL = baseURL.appendingPathComponent("checkLogin")
       
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["email": email,
                    "password": password]
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, _) in
            
            guard let data = data else {
                completion(nil, nil, nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let authModel = try? jsonDecoder.decode(AuthModel.self, from: data)
            
            
            guard let response = response else {
                    completion(nil, nil, nil)
                return
            }
            let postResponse = response as! HTTPURLResponse
            let code = postResponse.statusCode
            let message = postResponse.description

            completion(authModel, code, message)
            
            
        }
        task.resume()
    }
    
    
    
    
    
    func updateProfile(profile: UpdateUserModel, completion: @escaping ( _ responseCode: Int?, _ responseMessage: String?) -> Void){
      let loginURL = baseURL.appendingPathComponent("checkLogin")
       
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = profile
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, _) in
            
            
            guard let response = response else {
                    completion(nil, nil)
                return
            }
            let postResponse = response as! HTTPURLResponse
            let code = postResponse.statusCode
            let message = postResponse.description

            completion(code, message)
            
            
        }
        task.resume()
    }
    
    
    
    
    
    
    func uploadAvatar(imageToUpload: UIImage) {
        let avatarURL = baseURL.appendingPathComponent("uploadAvatar")
        
        var request = URLRequest(url: avatarURL)
        request.httpMethod = "POST";

        let formdata = [
            "key"  : "file",
            "type"    : "file",
        ]

        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = imageToUpload.jpegData(compressionQuality: 1)
        if imageData == nil  {
            return
        }

        request.httpBody = createBodyWithParameters(parameters: formdata, filePathKey: "src", imageDataKey: imageData! as NSData, boundary: boundary) as Data

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
        

                if error != nil {
                    print("error=\(error!)")
                    return
                }

                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("response data = \(responseString!)")

            }

            task.resume()
        }
    
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
            let body = NSMutableData();

            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }

            let filename = "avatar.jpg"
            let mimetype = "image/jpg"

            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageDataKey as Data)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)--\r\n")

            return body
        }

    
        func generateBoundaryString() -> String {
            return "Boundary-\(NSUUID().uuidString)"
        }
    

}



extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
