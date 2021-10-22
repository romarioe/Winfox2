//
//  NetworkService.swift
//  Winfox2
//
//  Created by Roman Efimov on 21.10.2021.
//

import Foundation


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
    
    
    
   
    
    
    
}
