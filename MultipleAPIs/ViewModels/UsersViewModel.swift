//
//  PhotosViewModel.swift
//  MultipleAPIs
//
//  Created by Cumulations Technologies Private Limited on 29/06/23.
//

import Foundation
class UsersViewModel {
    var users: [User] = []
    
    func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let apiURL = URL(string: APIConstants.baseURL + APIConstants.users)!
        
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
                let fetchedPhotos = try decoder.decode([User].self, from: jsonData)
                self.users = fetchedPhotos
                
                completion(fetchedPhotos, nil)
                
            } catch {
                completion(nil, error)
            }
        }
    }
}
