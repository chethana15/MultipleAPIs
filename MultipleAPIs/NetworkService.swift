//
//  NetworkService.swift
//  MultipleAPIs
//
//  Created by Cumulations Technologies Private Limited on 27/06/23.
//

import Foundation
import Alamofire

class APIService : RequestInterceptor{
    static var shared = APIService()


    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        return Session(configuration: configuration, interceptor: networkManagerInterceptor())
    }()
    func getAPI(url:URL,parameters:[String:Any]?,headers:HTTPHeaders?,Method:HTTPMethod,completion: @escaping (Int,Error?,Any?) -> Void){

        if(!Connectivity.isConnectedToInternet()){
//            UiUtils.showToast(message: "No internet connection")
            return completion(0,nil,nil)
        }
        let encoding = JSONEncoding.default as ParameterEncoding

        sessionManager.request(url, method:Method, parameters: parameters,encoding: encoding,headers: headers).validate().responseJSON { response in
            if(response.response?.statusCode == 401){
            }
            if let data = response.data {
            let json = String(data: data, encoding: String.Encoding.utf8)
                print("Failure Response: \(String(describing: json))")
            }
            guard let items = response.value else {
                return completion(response.response?.statusCode ?? 0, response.error, response.data)
            }
            completion(response.response?.statusCode ?? 0, response.error, items)
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class networkManagerInterceptor: RequestInterceptor {
    
    //1
    let retryLimit = 3
    let retryDelay: TimeInterval = 10
    typealias completionHandler = ((Result<Data, Error>) -> Void)
    //2
    func request(_ url: String, method: HTTPMethod = .get, parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil,
                 interceptor: RequestInterceptor? = nil, completion: @escaping completionHandler) {
        print("------REQUEST------")
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor ?? self).validate().responseJSON { (response) in
            if let data = response.data {
                completion(.success(data))
            } else {
                completion(.failure(response.error!))
            }
        }
    }
    
}
