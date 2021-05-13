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
  static let staging    = "https://sboom-staging.herokuapp.com"
  static let production = "https://sboom.herokuapp.com"
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
  private let verboseLogging = true

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

    if verboseLogging {
      print("\n----- REQUEST DETAILS -----")
      print("\(method.rawValue.uppercased())-request to \"\(endpoint)\"")
      print("Full URL = \(requestURL)")
      print("\t\tHEADERS:\n\(headersToSend)")
      print("\t\tPARAMETERS:\n\(params ?? [:])")
      print("----- REQUEST DETAILS END -----\n")
    }

    AF.request(requestURL,
               method: method,
               parameters: params,
               encoding: encoding,
               headers: headersToSend)
      .responseJSON { (response) in

        if self.verboseLogging {
          print("\n----- FULL RESPONSE -----")
          print("\(response)")
          print("----- FULL RESPONSE END -----\n")
        }

        // TODO: тут надо проверить HTTP код ответа и выдать стандартную ошибку, если код не из серии 200

        switch response.result {
        case .success(let value):
          let jsonResponse = JSON(value)
          let error = jsonResponse["error"]
          if error.isEmpty  {
            completeHandler(true, JSON(value), [])
          } else {
            completeHandler(false, JSON(), [jsonResponse])
          }
        case .failure(let error):
          let parsingError = JSON(["error": "Некорректные данные",
                                   "error_text": error.errorDescription])
          completeHandler(false, JSON(), [JSON(parsingError)])
        }
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
