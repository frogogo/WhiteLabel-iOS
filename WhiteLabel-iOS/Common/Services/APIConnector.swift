import Foundation
import Alamofire
import SwiftyJSON

typealias CompleteHandler = (_ isSuccess: Bool, _ response: JSON, _ errors: [JSON]) -> Void

enum APIErrorType {
  case unknown
  case connection
  case authorization
  case notFound
  case validation
}

private struct Host {
  static let staging    = "https://zboom-staging.herokuapp.com"
  // TODO: need to provide real production api URL
  static let production = "PRODUCTION API URL HERE"
}

/**
 A wrapper class for network module
 */
class APIConnector {
  // MARK: - Properties
  static let shared = APIConnector()

  private static let host = Host.staging
  private static let route = "api"
  private static let baseURL = host + "/" + route

  var authToken = ""

  private let defaultAPIVersion = "1"

  // MARK: - Custom open/public/internal methods
  func requestGET(_ endpoint: String, params: [String: Any]? = nil, useAuth: Bool = true, apiVersion: String? = nil, completeHandler: @escaping CompleteHandler) {
    print("\(type(of: self)): sending GET request to \"\(endpoint)\"")
    sendRequest(to: endpoint, withMethod: .get, params: params, encoding: URLEncoding.default, addAuthToken: useAuth, apiVersion: apiVersion, andCompleteHandler: completeHandler)
  }

  func requestPOST(_ endpoint: String, params: [String: Any]? = nil, useAuth: Bool = true, apiVersion: String? = nil, completeHandler: @escaping CompleteHandler) {
    print("\(type(of: self)): sending POST request to \"\(endpoint)\"")
    sendRequest(to: endpoint, withMethod: .post, params: params, encoding: JSONEncoding.default, addAuthToken: useAuth, apiVersion: apiVersion, andCompleteHandler: completeHandler)
  }

  func requestPATCH(_ endpoint: String, params: [String: Any]? = nil, useAuth: Bool = true, apiVersion: String? = nil, completeHandler: @escaping CompleteHandler) {
    print("\(type(of: self)): sending PATCH request to \"\(endpoint)\"")
    sendRequest(to: endpoint, withMethod: .patch, params: params, encoding: JSONEncoding.default, addAuthToken: useAuth, apiVersion: apiVersion, andCompleteHandler: completeHandler)
  }

  func requestDELETE(_ endpoint: String, params: [String: Any]? = nil, useAuth: Bool = true, apiVersion: String? = nil, completeHandler: @escaping CompleteHandler) {
    print("\(type(of: self)): sending DELETE request to \"\(endpoint)\"")
    sendRequest(to: endpoint, withMethod: .delete, params: params, encoding: JSONEncoding.default, addAuthToken: useAuth, apiVersion: apiVersion, andCompleteHandler: completeHandler)
  }

  // MARK: - Custom private methods
  private func sendRequest(to endpoint: String,
                           withMethod method: Alamofire.HTTPMethod,
                           params: Parameters?,
                           encoding: ParameterEncoding,
                           addAuthToken: Bool,
                           apiVersion: String?,
                           andCompleteHandler completeHandler:@escaping CompleteHandler) {

    let requestURL = APIConnector.baseURL + "/" + endpoint
    var headersToSend: HTTPHeaders = ["Accept": "application/json",
                                      "Content-Type": "application/json",
                                      "API-Version": defaultAPIVersion]

    if addAuthToken {
      if authToken == "" {
        completeHandler(false, JSON(""), [standardError(withType: .authorization)])
        return
      } else {
        headersToSend["Authorization"] = "Bearer " + authToken
      }
    }

    if let overriddenAPIVersion = apiVersion {
      headersToSend["API-Version"] = overriddenAPIVersion
    }

    AF.request(requestURL,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headersToSend)
      .responseJSON { [unowned self] (jsonResponse) in

        print("\(type(of: self)): full response \(jsonResponse)")

        guard let response = jsonResponse.response else {
          completeHandler(false, JSON(""), [self.standardError(withType: .connection)])
          return
        }

        var isSuccess = false
        var occuredErrors: [JSON] = []

        switch response.statusCode {
        case 200..<300:
          isSuccess = true
        case 401:
          occuredErrors = [self.standardError(withType: .authorization)]
        case 404:
          occuredErrors = [self.standardError(withType: .notFound)]
        case 422:
          occuredErrors = [JSON(jsonResponse)]
        default:
          print("\(type(of: self)): Unknown error occured. HTTP code \(response.statusCode). Failed \(method.rawValue.uppercased())-request with URL = \(requestURL) ")
          occuredErrors = [self.standardError(withType: .unknown)]
        }
        completeHandler(isSuccess, JSON(jsonResponse), occuredErrors)
    }
  }

  private func standardError(withType errorType: APIErrorType) -> JSON {
    var errorName = ""
    var errorMessage = ""
    switch errorType {
    case .unknown:
      errorName = "Неизвестная ошибка"
      errorMessage = "Неизвестная ошибка"
    case .connection:
      errorName = "Ошибка соединения с сервером"
      errorMessage = "Ошибка соединения с сервером"
    case .authorization:
      errorName = "Ошибка авторизации"
      errorMessage = "Ошибка авторизации"
    case .notFound:
      errorName = "Данные отсутствуют"
      errorMessage = "Данные отсутствуют"
    default:
      break
    }
    return JSON(["error": errorName, "error_text": errorMessage])
  }
}
