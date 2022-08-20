//
//  NetworkService.swift
//  CandleSticks-Chart
//
//  Created by Mohamed Farghaly on 20/08/2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchRequest<T: Decodable>(forRoute route: CSRouter, completion: @escaping(Result<T, NetworkError>) -> Void)
}

class NetworkService: NetworkServiceProtocol {

    func fetchRequest<T>(forRoute route: CSRouter,
                         completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        do {
            let urlRequest = try route.asURLRequest()
            URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if let data = data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                    }
                    if let httpResponse = response as? HTTPURLResponse,
                       !(200 ... 299).contains(httpResponse.statusCode) {
                    let txtError = self.handleError(forCode: httpResponse.statusCode)
                        print("\(txtError)")
                        return
                    }
                    guard let data = data else {
                        completion(.failure(.parsingError))
                        return
                    }
                    do {
                        let reviews = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(reviews))
                    } catch {
                        print("Error: \(error)")
                        completion(.failure(.parsingError))
                    }
                }
            }).resume()
        } catch {
            completion(.failure(.unknownError))
        }
    }

    private func handleError(forCode code: Int) -> NetworkError {
        switch code {
        case 500...599:
        return .internalServerError
        case 400 ... 499:
        return .clientErrors
        default:
        return .unknownError
        }
    }

}
