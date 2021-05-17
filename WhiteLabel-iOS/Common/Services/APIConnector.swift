import Foundation
import Alamofire
import SwiftyJSON

typealias CompleteHandler = (_ isSuccess: Bool, _ response: JSON, _ errors: [APIError]) -> Void

enum APIErrorType {
  case unknown
  case connection
  case authorization
  case notFound
  case validation
}

struct APIError {
  var name: String
  var description: String
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

  private static let host = Host.production
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
      print("\n    ----- REQUEST DETAILS -----")
      print("\(method.rawValue.uppercased())-request to \"\(endpoint)\"")
      print("Full URL = \(requestURL)")
      print("\t\tHEADERS:\n\(headersToSend)")
      print("\t\tPARAMETERS:\n\(params ?? [:])")
      print("    ----- REQUEST DETAILS END -----\n")
    }

    AF.request(requestURL,
               method: method,
               parameters: params,
               encoding: encoding,
               headers: headersToSend)
      .responseJSON {[weak self] (response) in
        guard let self = self else { return }

        // TODO: тут надо проверить HTTP код ответа и выдать стандартную ошибку, если код не из серии 200
        guard let httpCode = response.response?.statusCode else {
          let unknownError = self.standardError(withType: .unknown)
          completeHandler(false, JSON(), [unknownError])
          return
        }

        if self.verboseLogging {
          print("\n    ----- FULL RESPONSE -----")
          print("\nhttp code \(httpCode)")
          print("\n\(response)")
          print("    ----- FULL RESPONSE END -----\n")
        }

        var parsedResponse = JSON()
        var occuredErrors = [self.standardError(withType: .unknown)]
        var isSuccess = false

        switch httpCode {
        case 200..<300:
          if let validResponse = response.value {
            isSuccess = true
            parsedResponse = JSON(validResponse)
            occuredErrors = []
          }
        case 401:
          occuredErrors = [self.standardError(withType: .authorization)]
        case 404:
          occuredErrors = [self.standardError(withType: .notFound)]
        case 422:
          if let validErrorBody = response.value {
            let errorBody = JSON(validErrorBody)
            let errorName = errorBody["error"].stringValue
            let errorDescription = errorBody["error_text"].stringValue
            occuredErrors = [APIError(name: errorName, description: errorDescription)]
          } else {
            print("\(type(of: self)): не удалось распарсить ошибку валидации! Создана неизвестная ошибка")
            occuredErrors = [self.standardError(withType: .unknown)]
          }
        default:
          occuredErrors = [self.standardError(withType: .unknown)]
        }

        completeHandler(isSuccess, parsedResponse, occuredErrors)
      }
  }

  private func standardError(withType errorType: APIErrorType) -> APIError {
    let error: APIError?
    switch errorType {
    case .unknown:
      error = APIError(name: "Неизвестная ошибка",
                       description: "Неизвестная ошибка")
    case .connection:
      error = APIError(name: "Ошибка соединения с сервером",
                       description: "Ошибка соединения с сервером")
    case .authorization:
      error = APIError(name: "Ошибка авторизации",
                       description: "Ошибка авторизации")
    case .notFound:
      error = APIError(name: "Данные отсутствуют",
                       description: "Данные отсутствуют")
    default:
      print("\(type(of: self)): Error creation with type \(errorType) not supported. Created unknown error instead")
      error = APIError(name: "Неизвестная ошибка",
                       description: "Неизвестная ошибка")
      break
    }
    return error!
  }
}
