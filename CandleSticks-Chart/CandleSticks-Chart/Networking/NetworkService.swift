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
                        if let utf8Text = String(data: data, encoding: .utf8) {
                            var candleDataViewModel: [ChartModel] = [ChartModel]()
                            let arrayData = utf8Text.replacingOccurrences(of: "],[", with: "]  [").dropFirst().dropLast().replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "\"", with: "").components(separatedBy: "  ")
                            print("Data: \(arrayData)")
                            for i in 0...arrayData.count - 1 {
                               let newArr = arrayData[i].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",")
                                candleDataViewModel.append(ChartModel(openTime: Int(newArr[0])!, open: String(newArr[1]), high: String(newArr[2]), low: String(newArr[3]), volume: String(newArr[4]), close: String(newArr[5]), closeTime: Int(newArr[6])!, qAssetVolume: String(newArr[7]), numberoftrades: Int(newArr[8])!, tbBAssetVolume: String(newArr[9]), tbQAssetVolume: String(newArr[10]), ignoreVal: String(newArr[11])))
                            }
                            let val = candleDataViewModel.compactMap({$0.dict})
                            print("val: \(val)")
                            let jsonData = try JSONSerialization.data(withJSONObject: val, options: [])
                                let reviews = try JSONDecoder().decode(T.self, from: jsonData)
                                completion(.success(reviews))

                        }
                      
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
