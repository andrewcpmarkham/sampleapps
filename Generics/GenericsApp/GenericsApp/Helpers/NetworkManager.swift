//
//  NetworkManager.swift
//  GenericsApp
//
//  Created by Andrew CP Markham on 21/2/21.
//

import Foundation

enum NetworkError: Error {
    case failed(error: Error)
    case invalidResponse(response: URLResponse)
    case emptyData
}

class GenericNetworkManager<T: Codable> {
    func fetch(url: URL, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.failed(error: error!)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,  httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse(response: response!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            
            let json = try? JSONDecoder().decode(T.self, from: data)
            completion(.success(json))
            
        }.resume()
    }
}
