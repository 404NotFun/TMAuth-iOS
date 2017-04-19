//
//  TMAuth.swift
//  TMAuth
//
//  Created by Jason Tsai on 2017/4/20.
//  Copyright © 2017年 YomStudio. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import TMCore

class TMAuth {
    static let shared = TMAuth()
    public var SERVER_DOMAIN = ""
    public var REQUEST_CONFIG: [String: String] = ["Client-Service":"frontend-client","Auth-Key":"macFyDevApi", "User-ID": "", "Authorization": "", "Cache-Control": "no-cache"]
    
    // MARK: - POST
    // 1. 註冊{username, email, password}
    func signUp(user: TMUser, completion: @escaping(NSDictionary)->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/register"
            let tempAry = NSArray.init(array: user.favorites)
            let parameters: Parameters = [
                "username"    : user.username,
                "email"       : user.email,
                "password"    : user.password,
                
                "identity" : user.identity,
                "location" : user.location_id,
                "department"  : user.department,
                "grade"    : user.grade,
                "favorites"   : tempAry.componentsJoined(by: ","),
                "nickname"    : user.nickname,
                "gender"      : user.gender,
                "confirm_code": user.confirmCode
            ]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON{ response in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse as! NSDictionary)
                }else {
                    failure()
                }
            }
        }
    }
    
    // 註冊{email, fb_id, profile_photo_url}
    func signUpByFacebook(user: TMUser, completion: @escaping(NSDictionary)->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/register/facebook"
            let tempAry = NSArray.init(array: user.favorites)
            let parameters: Parameters = [
                "username"    : user.username,
                "email"       : user.fbId,
                "nickname"    : user.nickname,
                "name"        : user.nickname,
                "is_email_verified" : 1,
                "profile_photo_url": user.profilePhotoUrl,
                "fb_id" : user.fbId,
                "confirm_code": "sFiB",
                
                "identity" : user.identity,
                "location" : user.location_id,
                "department"  : user.department,
                "grade"    : user.grade,
                "favorites"   : tempAry.componentsJoined(by: ","),
                "gender"      : user.gender
            ]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON{ response in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse as! NSDictionary)
                }else {
                    failure()
                }
            }
        }
    }
    
    // 註冊{email, g_id, profile_photo_url}
    func signUpByGoogle(user: TMUser, completion: @escaping(NSDictionary)->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/register/google"
            let tempAry = NSArray.init(array: user.favorites)
            let parameters: Parameters = [
                "username"    : user.username,
                "email"       : user.gId,
                "nickname"    : user.nickname,
                "name"        : user.nickname,
                "is_email_verified" : 1,
                "profile_photo_url": user.profilePhotoUrl,
                "g_id"  : user.gId,
                "confirm_code": "sGio",
                
                "identity" : user.identity,
                "location" : user.location_id,
                "department"  : user.department,
                "grade"    : user.grade,
                "favorites"   : tempAry.componentsJoined(by: ","),
                "gender"      : user.gender
            ]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON{ response in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse as! NSDictionary)
                }else {
                    failure()
                }
            }
        }
    }
    
    // 登入{token}
    func signIn(token: String, completion: @escaping(_ response: [String: Any])->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/login/token"
            let parameters: [String: String] = ["token": token]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: {response in
                if response.response?.statusCode == 200 || response.response?.statusCode == 400{
                    let responseJSON = response.result.value
                    if let defaultResponse = responseJSON {
                        completion(defaultResponse as! [String : Any])
                    }else {
                        failure()
                    }
                }else {
                    failure()
                }
            })
        }
    }
    
    // 登入{email, password}
    func signIn(user: TMUser, completion: @escaping(_ response: [String: Any])->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/login"
            let parameters: [String: String] = ["username": user.username, "password": user.password]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: {response in
                if response.response?.statusCode == 200 || response.response?.statusCode == 400{
                    let responseJSON = response.result.value
                    if let defaultResponse = responseJSON {
                        completion(defaultResponse as! [String : Any])
                    }else {
                        failure()
                    }
                }else {
                    failure()
                }
            })
        }
    }
    
    // 登入{fbId, accessToken}
    func signInByFacebook(fbId: String, completion: @escaping(_ response: [String: Any])->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let parameters: Parameters = ["fb_id": fbId]
            let url: String = self.SERVER_DOMAIN+"auth/login/facebook"
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: { response in
                let responseJSON = response.result.value
                if response.response?.statusCode == 200 {
                    if let user = responseJSON {
                        completion(user as! [String : Any])
                    }else {
                        failure()
                    }
                }else {
                    failure()
                }
            })
        }
    }
    
    // 登入{gId, accessToken}
    func signInByGoogle(gId: String, completion: @escaping(_ response: [String : Any])->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let parameters: Parameters = ["g_id": gId]
            let url: String = self.SERVER_DOMAIN+"auth/login/google"
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: { response in
                let responseJSON = response.result.value
                if response.response?.statusCode == 200 {
                    if let user = responseJSON {
                        completion(user as! [String : Any])
                    }else {
                        failure()
                    }
                }else {
                    failure()
                }
            })
        }
    }
    
    func checkFBAccessToken(accessToken: String, completion: @escaping (Bool)->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = "https://graph.facebook.com/app?access_token="+accessToken
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: { response in
                if response.response?.statusCode == 200 {
                    completion(true)
                }else {
                    completion(false)
                }
            })
        }
    }
    
    func checkGoogleAccessToken(accessToken: String, completion: @escaping (Bool)->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token="+accessToken
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: { response in
                if response.response?.statusCode == 200 {
                    completion(true)
                }else {
                    completion(false)
                }
            })
        }
    }
    
    func signOut(id: String, token: String, completion: @escaping(_ response: [String: Any])->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/logout"
            let parameters: [String: String] = ["users_id": id, "token": token]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: {response in
                if response.response?.statusCode == 200 {
                    let responseJSON = response.result.value
                    if let defaultResponse = responseJSON {
                        completion(defaultResponse as! [String : Any])
                    }else {
                        failure()
                    }
                }else if response.response?.statusCode == 204 {
                    failure()
                }else {
                    failure()
                }
            })
        }
    }
    
    // 檢查{email}的FBAuth狀態
    func checkFBAuthStatus(email: String, completion: @escaping(_ response: [String: Any])->(), failure: @escaping (_ error: Error)->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/FBAuthStatus"
            let parameters: [String: String] = ["email": email]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: {response in
                if response.response?.statusCode == 200 {
                    let responseJSON = response.result.value
                    if let defaultResponse = responseJSON {
                        completion(defaultResponse as! [String : Any])
                    }else {
                        failure(response.result.error!)
                    }
                }else if response.response?.statusCode == 204 {
                    failure(response.result.error!)
                }else {
                    failure(response.result.error!)
                }
            })
        }
    }
    
    // 檢查{email}的GoogleAuth狀態
    func checkGoogleAuthStatus(email: String, completion: @escaping(_ response: [String: Any])->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/GoogleAuthStatus"
            let parameters: [String: String] = ["email": email]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: {response in
                if response.response?.statusCode == 200 {
                    let responseJSON = response.result.value
                    if let defaultResponse = responseJSON {
                        completion(defaultResponse as! [String : Any])
                    }else {
                        failure()
                    }
                }else if response.response?.statusCode == 204 {
                    failure()
                }else {
                    failure()
                }
            })
        }
    }
    
    // 檢查{fb_id}的FBAuth狀態
    func checkFacebookAuthValidation(fbId: String, completion: @escaping(_ response: [String: Any])->(), failure: @escaping (_ error: Error)->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/facebookAuthValidation"
            let parameters: [String: String] = ["fb_id": fbId]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: {response in
                if response.response?.statusCode == 200 || response.response?.statusCode == 400 {
                    let responseJSON = response.result.value
                    if let defaultResponse = responseJSON {
                        completion(defaultResponse as! [String : Any])
                    }else {
                        failure(response.result.error!)
                    }
                }else {
                    failure(response.result.error!)
                }
            })
        }
    }
    
    // 檢查{g_id}的GoogleAuth狀態
    func checkGoogleAuthValidation(gId: String, completion: @escaping(_ response: [String: Any])->(), failure: @escaping (Error)->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url: String = self.SERVER_DOMAIN+"auth/googleAuthValidation"
            let parameters: [String: String] = ["g_id": gId]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: {response in
                if response.response?.statusCode == 200 || response.response?.statusCode == 400 {
                    let responseJSON = response.result.value
                    if let defaultResponse = responseJSON {
                        completion(defaultResponse as! [String : Any])
                    }else {
                        failure(response.result.error!)
                    }
                }else {
                    failure(response.result.error!)
                }
            })
        }
    }
    
    // MARK: - GET
    // 檢查{username}
    func checkExists(username: String, completion:(@escaping (NSDictionary)->()), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/checkUsername/"+username
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: { response in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse as! NSDictionary)
                }else {
                    failure()
                }
            })
        }
    }
    
    // 檢查{email}
    func checkExists(email: String, completion:(@escaping (_ response: TMResponse)->()), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/checkEmail/"+email
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse)
                }
            })
        }
    }
    
    // 檢查{email}用戶的{confirm_code}是否正確
    func checkConfirmCode(_ code: String, email: String, completion: @escaping (_ isMatch: Bool)->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/checkConfirmCode/"+code+"/email/"+email
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    if defaultResponse.status == 200 {
                        completion(true)
                    }else {
                        completion(false)
                    }
                }else {
                    failure()
                }
            })
        }
    }
    
    // 檢查{username}用戶的{confirm_code}是否正確
    func checkConfirmCode(_ code: String, username: String, completion: @escaping (_ isMatch: Bool)->(), failure: @escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/checkConfirmCode/"+code+"/username/"+username
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    if defaultResponse.status == 200 {
                        completion(true)
                    }else {
                        completion(false)
                    }
                }else {
                    failure()
                }
            })
        }
    }
    
    // 取得{id}的用戶
    func getUserData(id: String, completion: @escaping (_ response: TMUser)->(), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/detail/"+id
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMUser>) in
                let responseJSON = response.result.value
                if response.response?.statusCode == 200 {
                    if let user = responseJSON {
                        completion(user)
                    }else {
                        failure()
                    }
                }else {
                    failure()
                }
            })
        }
    }
    
    // 取得{id}的用戶
    func getUser(id: String, completion: @escaping (_ response: TMUser)->(), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"users/"+id
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMUser>) in
                let responseJSON = response.result.value
                if response.response?.statusCode == 200 {
                    if let user = responseJSON {
                        completion(user)
                    }else {
                        failure()
                    }
                }else {
                    failure()
                }
            })
        }
    }
    
    // 取得{id}用戶的favorites
    func getFavorites(id: String, completion: @escaping (NSDictionary)->(), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/favorites/"+id
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseJSON(completionHandler: { response in
                let responseJSON = response.result.value
                if response.response?.statusCode == 200 {
                    if let responseObj = responseJSON {
                        completion(responseObj as! NSDictionary)
                    }else {
                        failure()
                    }
                }else {
                    failure()
                }
            })
        }
    }
    
    
    
    // MARK: - PUT
    // 更新{id}的用戶
    func update(id: String, parameters: [String: String], completion:(@escaping (_ response: TMResponse)->()), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/updateById/"+id
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse)
                }else {
                    failure()
                }
            })
        }
    }
    
    // 更新{email}的用戶
    func update(email: String, parameters: [String: String], completion:(@escaping (_ response: TMResponse)->()), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/updateByEmail/"+email
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse)
                }
            })
        }
    }
    
    // Public更新{email}的用戶
    func updatePublic(email: String, parameters: [String: String], completion:(@escaping (_ response: TMResponse)->()), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/updatePublicByEmail/"+email
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse)
                }
            })
        }
    }
    
    // 綁定{user_id}臉書帳號
    func boundFBAuth(params: Parameters, completion: @escaping(_ response: TMResponse)->(), failure: @escaping (_ errorMsg: String)->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/bound/facebook"
            Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    if response.response?.statusCode == 200 {
                        completion(defaultResponse)
                    }else if response.response?.statusCode == 400 {
                        failure(defaultResponse.message!)
                    }else {
                        failure(defaultResponse.message!)
                    }
                }else {
                    failure((response.result.error?.localizedDescription)!)
                }
            })
        }
    }
    
    // 綁定{user_id}Google帳號
    func boundGoogleAuth(params: Parameters, completion: @escaping(_ response: TMResponse)->(), failure: @escaping (_ errorMsg: String)->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/bound/google"
            Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    if response.response?.statusCode == 200 {
                        completion(defaultResponse)
                    }else if response.response?.statusCode == 400 {
                        failure(defaultResponse.message!)
                    }
                }else {
                    failure((response.result.error?.localizedDescription)!)
                }
            })
        }
    }
    
    // 更新{email}用戶的{password}
    func update(_ email: String, password: String, completion:@escaping ()->(), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/changePassword/"+email
            let parameters: [String: String] = ["password": password];
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if responseJSON != nil && response.response?.statusCode == 200 {
                    completion()
                }else {
                    failure()
                }
            })
        }
    }
    
    // {id}用戶積分增加{add_exp}
    func increment(_ id: String, exp: Int, completion:(@escaping (_ response: TMResponse)->()), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/user/"+id+"/incrementExp/"+String(exp)
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse)
                }else {
                    failure()
                }
            })
        }
    }
    
    // {username}用戶積分增加{add_exp}
    func increment(username: String, exp: Int, completion:(@escaping (_ response: TMResponse)->()), failure:@escaping ()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"auth/username/"+username+"/incrementExp/"+String(exp)
            Alamofire.request(url, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseObject(completionHandler: { (response: DataResponse<TMResponse>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse)
                }else {
                    failure()
                }
            })
        }
    }
}

/*
extension TMAuth {
    // 取得提交商家數前(TopNumber)
    func getUsersProvidedShops(topNumber: Int, completion: @escaping([UserRanking])->(), failure: @escaping()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"users/top/"+String(topNumber)+"/shops"
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseArray(completionHandler: { (response: DataResponse<[UserRanking]>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse)
                }else {
                    FNLog(type: .Remote, msg: (response.result.error?.localizedDescription)!)
                    failure()
                }
            })
        }
    }
    
    // 取得積分前(TopNumber)
    func getUsersMostExp(topNumber: Int, completion: @escaping([UserRanking])->(), failure: @escaping()->()) {
        NetworkingManager.sharedInstance.connectedNetworking {
            let url = self.SERVER_DOMAIN+"users/top/"+String(topNumber)+"/exp"
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.REQUEST_CONFIG).responseArray(completionHandler: { (response: DataResponse<[UserRanking]>) in
                let responseJSON = response.result.value
                if let defaultResponse = responseJSON {
                    completion(defaultResponse)
                }else {
                    FNLog(type: .Remote, msg: (response.result.error?.localizedDescription)!)
                    failure()
                }
            })
        }
    }
}
*/
