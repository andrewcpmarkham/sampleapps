//: [Previous](@previous)

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

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

//Object to decode to
struct Person: Codable {
    let name: String
    let gender: String
    let homeworld: String
    let films: [String]
}

struct SWAPIEnvelope: Codable {
    let results: [Person]
}

struct Film: Codable {
    let title: String
    let opening_crawl: String
    let director: String
}

GenericNetworkManager<SWAPIEnvelope>().fetch(url: URL(string: "https://swapi.dev/api/people/?search=sky")!) { (results) in
    switch results {
    case .failure(let error):
        print(error)
    case .success(let data):
        print(data ?? "---- NO DATA ----")
        
        getFilm(for: data?.results[0])
    }
}


func getFilm(for person: Person?){
    guard let person = person else {
        return
    }
    
    GenericNetworkManager<Film>().fetch(url: URL(string: person.films[0])! ) { (results) in
        switch results {
        case .failure(let err):
            print(err)
        case .success(let film):
            print(film ?? "---- NO DATA ----")
        }
    }
}
