//
//  CSRouter.swift
//  CandleSticks-Chart
//
//  Created by Mohamed Farghaly on 20/08/2022.
//

import Foundation

enum CSRouter {

    // MARK: - Endpoints
    case getSticksLines(symbol:String, interval:String, limit:String)

    // MARK: - Properties
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getSticksLines:
            return Config.EndpointPath.getSticksLines
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getSticksLines(let symbol, let interval, let limit):
            let parameters = ["symbol":symbol,"interval": interval,"limit":limit] as [String : Any]
            return parameters
        default:
         return nil

        }
    }

    // MARK: - Methods
    func asURLRequest() throws -> URLRequest {
        let endpointPath: String = "\(Config.baseURL)\(path)"
        var components = URLComponents(string: endpointPath)
        var urlRequest = URLRequest(url: (components?.url)!)
        components?.queryItems = []
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
            components?.queryItems?.append(contentsOf: parameters!.map { (key, value) in
                URLQueryItem(name: key, value: value as? String)
            })
       
        urlRequest.url = components?.url

        return urlRequest
    }
}
