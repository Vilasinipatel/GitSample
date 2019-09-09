//
//  ServiceActivity.swift
//  GitSample
//
//  Created by Villasini Patel on 09/09/19.
//  Copyright © 2019 vils. All rights reserved.
//

import Foundation



public class Services{
    
    class func serviceCall(token: String, url : String, methodType: String, httpBody : Data?,onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if(!token.isEmpty){
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = methodType
        if(httpBody?.count != 0)
        {
            request.httpBody = httpBody
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                onFailure(error!)
                return
            }
                if let httpResponse = response as? HTTPURLResponse {
                    print("error \(httpResponse.statusCode)")
                    if(httpResponse.statusCode == 200){
                        onSuccess(data)
                    }else{
                        onFailure(error!)
                    }
                }
        }
        task.resume()
    }
    
    class func getAccessToken(code: String,onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
            let parameterDictionary = ["client_id" : Constant.client_id, "client_secret" : Constant.client_secret_id, "code" : code]
                guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                    return
                }
            serviceCall(token: "", url: Constant.gitAccessTokenUrl, methodType: "POST", httpBody: httpBody, onSuccess: onSuccess, onFailure: onFailure)
    }
    
 
    class func getGitUser(onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        let oauthToken = UserDefaults.standard.value(forKey: "oauthToken")! as! String
serviceCall(token: oauthToken, url: Constant.gitUserDetailUrl, methodType: "GET", httpBody: nil, onSuccess: onSuccess, onFailure: onFailure)
    
    }
    
    class func getUserRepos(repoUrl: String, onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        
        let oauthToken = UserDefaults.standard.value(forKey: "oauthToken")! as! String
        serviceCall(token: oauthToken, url: repoUrl, methodType: "GET", httpBody: nil, onSuccess: onSuccess, onFailure: onFailure)
        
    }
    
}
