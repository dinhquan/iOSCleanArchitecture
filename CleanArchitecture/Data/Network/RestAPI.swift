//
//  RestAPI.swift
//  NewsApp
//
//  Created by Dinh Quan on 2/4/21.
//

import Foundation
import Alamofire
import RxSwift

struct ResponseError: Error {
    enum ErrorType {
        case af
        case json
        case unknown
    }

    let type: ErrorType
    let error: Error?
    let afError: AFError?

    var message: String {
        switch type {
        case .af:
            return afError?.localizedDescription ?? ""
        case .json:
            return error?.localizedDescription ?? ""
        default:
            return "Unknown error"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"

    var afMethod: Alamofire.HTTPMethod {
        return Alamofire.HTTPMethod(rawValue: self.rawValue)
    }
}

protocol RestAPI {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var mockFile: String { get }

    func request<T: Decodable, K: Encodable>(returnType: T.Type, paramType: K.Type, params: K, completion: @escaping (_ result: T?, _ error: ResponseError?) -> Void)

    func request<T: Decodable>(returnType: T.Type, completion: @escaping (_ result: T?, _ error: ResponseError?) -> Void)

    func request<T: Decodable, K: Encodable>(returnType: T.Type, paramType: K.Type, params: K) -> Single<T>

    func request<T: Decodable>(returnType: T.Type) -> Single<T>
}

extension RestAPI {
    var headers: HTTPHeaders {
        return [
            "Content-Type": "application/json"
        ]
    }

    var mockFile: String {
        return ""
    }

    func request<T: Decodable, K: Encodable>(returnType: T.Type, paramType: K.Type, params: K, completion: @escaping (_ result: T?, _ error: ResponseError?) -> Void) {
        if handleMock(returnType: returnType, completion: completion) {
            return
        }

        let url = "\(Config.current.baseUrl)/\(path)"

        print(">>> Network Request \(method.rawValue):", url)

        AF.request(url,
                   method: method.afMethod,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: T.self) { response in
                guard let value = response.value else {
                    let error = ResponseError(type: .af, error: nil, afError: response.error)
                    completion(nil, error)
                    return
                }
                completion(value, nil)
            }
    }

    func request<T: Decodable>(returnType: T.Type, completion: @escaping (_ result: T?, _ error: ResponseError?) -> Void) {
        if handleMock(returnType: returnType, completion: completion) {
            return
        }

        let url = "\(Config.current.baseUrl)/\(path)"

        print(">>> Network Request \(method.rawValue):", url)

        AF.request(url,
                   method: method.afMethod,
                   headers: headers)
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: T.self) { response in
                guard let value = response.value else {
                    let error = ResponseError(type: .af, error: nil, afError: response.error)
                    completion(nil, error)
                    return
                }
                completion(value, nil)
            }
    }

    func request<T: Decodable, K: Encodable>(returnType: T.Type, paramType: K.Type, params: K) -> Single<T> {
        return Single.create { single in
            request(returnType: returnType, paramType: paramType, params: params) { (result, error) in
                guard let result = result else {
                    single(.failure(error!))
                    return
                }
                single(.success(result))
            }
            return Disposables.create()
        }
    }

    func request<T: Decodable>(returnType: T.Type) -> Single<T> {
        return Single.create { single in
            request(returnType: returnType) { (result, error) in
                guard let result = result else {
                    single(.failure(error!))
                    return
                }
                single(.success(result))
            }
            return Disposables.create()
        }
    }

    private func handleMock<T: Decodable>(returnType: T.Type, completion: @escaping (_ result: T?, _ error: ResponseError?) -> Void) -> Bool {
        if Config.current.mockEnabled,
           !mockFile.isEmpty,
           let path = Bundle.main.path(forResource: mockFile, ofType: ""),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let decoder = JSONDecoder()
            do {
                let value = try decoder.decode(returnType, from: data)
                completion(value, nil)
            } catch {
                let error = ResponseError(type: .json, error: error, afError: nil)
                completion(nil, error)
            }

            return true
        }

        return false
    }
}
