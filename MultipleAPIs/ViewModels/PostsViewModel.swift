//
//  UsersViewModel.swift
//  MultipleAPIs
//
//  Created by Cumulations Technologies Private Limited on 27/06/23.
//

import Foundation
import Alamofire

class PostsViewModel {
    var posts: [Posts] = []
    
    func fetchPosts(completion: @escaping ([Posts]?, Error?) -> Void) {
        let apiURL = URL(string: APIConstants.baseURL + APIConstants.posts)!
        
        APIService.shared.getAPI(url: apiURL, parameters: nil, headers: nil, Method: .get) { statusCode, error, response in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let dictionaries = response as? [[String: Any]] else {
                let invalidResponseError = NSError(domain: "InvalidResponseError", code: 0, userInfo: nil)
                completion(nil, invalidResponseError)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dictionaries, options: [])
                let decoder = JSONDecoder()
                let fetchedPosts = try decoder.decode([Posts].self, from: jsonData)
                self.posts = fetchedPosts
                
                completion(fetchedPosts, nil)
                
            } catch {
                completion(nil, error)
            }
        }
    }
}
