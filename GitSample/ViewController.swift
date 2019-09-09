//
//  ViewController.swift
//  GitSample
//
//  Created by Villasini Patel on 09/09/19.
//  Copyright © 2019 vils. All rights reserved.
//

import UIKit
import AuthenticationServices

struct tokenDetail : Decodable {
    var access_token : String
    var token_type: String
}

class ViewController: UIViewController {
    var webAuthSession: ASWebAuthenticationSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
        //performSegue(withIdentifier: "RepoListViewSegue", sender: nil)

    }

    @IBAction func LoginAction(_ sender: Any) {
        self.getCodeAccessFromGit({ (data) in
            do{
                let repoArray = try JSONDecoder().decode(tokenDetail.self, from: data)
                print("TokenDetail:\(repoArray)")
                UserDefaults.standard.set(repoArray.access_token, forKey: "oauthToken")
                UserDefaults.standard.set(repoArray.token_type, forKey: "oauthType")
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "RepoListViewSegue", sender: nil)
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }) { (error) in
            print("Error to access to code\(error.localizedDescription)")
        }
        
    }
    
     func getCodeAccessFromGit(_ onSuccess: @escaping(Data) -> Void, onFailure: @escaping(Error) -> Void){
        let webAuthUrl = URL(string: "\(Constant.gitCodeAccessUrl)\(Constant.client_id)")
        let callbackUrl = Constant.callback_url;
        self.webAuthSession = ASWebAuthenticationSession.init(url: webAuthUrl!, callbackURLScheme:callbackUrl, completionHandler: { (callBack:URL?, error:Error?) in
            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }
            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            print(oauthToken ?? "No OAuth Token")
            if(oauthToken != nil){
              Services.getAccessToken(code: oauthToken?.value ?? "",onSuccess: onSuccess,onFailure: onFailure);
            }
        })
        self.webAuthSession?.start()
    }
}

