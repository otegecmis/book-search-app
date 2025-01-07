import UIKit
import Alamofire
import Network

enum APIError: String, Error {
    case networkError = "Please check your connection."
    case invalidResponse = "Invalid server response."
    case notFound = "The book was not found."
}

class APIService {
    
    // MARK: - Properties
    static let shared = APIService()
    
    private var session: Session
    private let cache = NSCache<NSString, UIImage>()
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    
    // MARK: - Initializers
    private init() {
        session = Self.createSession()
        setupNetworkMonitoring()
    }
    
    // MARK: - Helpers
    private static func createSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        configuration.waitsForConnectivity = true
        
        let interceptor = RetryPolicy(retryLimit: 3)
        return Session(configuration: configuration, interceptor: interceptor)
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self?.refreshSession()
                }
            }
        }
        
        monitor.start(queue: monitorQueue)
    }
    
    private func refreshSession() {
        session = Self.createSession()
    }
    
    func request<T: Decodable>(_ url: String, method: HTTPMethod, parameters: Parameters?, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    if let statusCode = response.response?.statusCode, statusCode == 404 {
                        completion(.failure(APIError.notFound))
                    } else if let underlyingError = error.underlyingError as? URLError {
                        completion(.failure(APIError.networkError))
                    } else {
                        completion(.failure(APIError.invalidResponse))
                    }
                }
            }
    }
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        session.request(urlString)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        self.cache.setObject(image, forKey: cacheKey)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                case .failure:
                    completion(nil)
                }
            }
    }
    
    deinit {
        monitor.cancel()
    }
}
