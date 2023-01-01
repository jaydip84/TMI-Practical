//
//  ServerHelper.swift
//  FlashcardsiOS
//
//  Created by Parveen Khatkar on 5/24/15.
//  Copyright (c) 2015 Codetrix Studio. All rights reserved.
//

import UIKit
import Alamofire


class MVCServer: NSObject
{
    
    let sharedSession: URLSession = URLSession.shared;

    
    func serviceRequestWithURL<T: Codable>(reqMethod: HTTPMethod, withUrl URL: String,withParam postParam: Dictionary<String, Any>, expecting: T.Type ,completion:@escaping (_ responseCode: Int, T?) -> Void)
    {
        

        let requetURL = URL
        
        print("URL",requetURL)
        print("****************** requetURL ******************")
        print(requetURL)
        print("****************** postParam ******************")
        print(postParam)
        print("***********************************************")
        
        AF.request(requetURL, method: reqMethod, parameters: postParam, encoding:URLEncoding.default , headers: ["Accept": "application/json"]).responseJSON
        { (response) in
            

            if let responseData = response.data,
               let desiredString = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue)
            {
                print("****************** Response ******************")
                print(desiredString)
                print("***********************************************")
            }
            
            switch response.result {
                
            case .failure(let error):
                print(error.localizedDescription)
                
                completion(0,nil)
                
                
            case .success(_):
                
                do{
                    let result = try JSONDecoder().decode(expecting, from: response.data!)
                    completion(1,result)
                }
                catch{
                    completion(0,nil)
                }
            }
        }
    }
}


