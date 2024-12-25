import Foundation
import UIKit
import RxSwift
import RxCocoa

enum APIError: Error {
    case error(String)
    case errorURL
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        }
    }
}

final class RegisterModel {
    
    //singleton
    private static var sharedRegisterModel: RegisterModel = {
        let sharedRegisterModel = RegisterModel()
        return sharedRegisterModel
    }()
    
    class func shared() -> RegisterModel {
        return sharedRegisterModel
    }
    
    // init
    private init() {}
    
    func register2(username: String?, password: String?, email: String?, avatar: UIImage?) -> Single<Bool> {
            return Single.create { single in
                // check params
                // username
                if let username = username {
                    if username == "" {
                        single(.failure(APIError.error("username is empty")))
                    }
                } else {
                    single(.failure(APIError.error("username is nil")))
                }
                
                // password
                if let password = password {
                    if password == "" {
                        single(.failure(APIError.error("password is empty")))
                    }
                } else {
                    single(.failure(APIError.error("password is nil")))
                }
                
                // email
                if let email = email {
                    if email == "" {
                        single(.failure(APIError.error("email is empty")))
                    }
                } else {
                    single(.failure(APIError.error("email is nil")))
                }
                
                // avatar
                if avatar == nil {
                    single(.failure(APIError.error("avatar is empty")))
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    single(.success(true))
                }
                
                return Disposables.create()
            }
        }
    
}

