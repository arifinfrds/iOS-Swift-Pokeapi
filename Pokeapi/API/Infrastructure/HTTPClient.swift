//
//  HTTPClient.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: url) { data, urlResponse, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let _ = urlResponse as? HTTPURLResponse, let receivedData = data {
                completion(.success(receivedData))
            } else {
                let error = NSError(domain: "\(type(of: URLSessionHTTPClient.self))", code: 1, userInfo: [:])
                completion(.failure(error))
            }
        }
        .resume()
    }
}
