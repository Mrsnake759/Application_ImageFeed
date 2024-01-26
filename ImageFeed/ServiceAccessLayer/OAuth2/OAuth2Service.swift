
import Foundation

final class OAuth2Service {
    enum NetworkError: Error {
        case codeError
        case unableToDecodeStringFromData
    }
    
    private var lastCode: String?
    private var currentTask: URLSessionTask?
    
    func fetchAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        currentTask?.cancel()
        lastCode = code
        
        guard let request = makeRequest(code: code) else { return }
        
        let session = URLSession.shared
        currentTask = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            self.currentTask = nil
            switch result {
            case .success(let oAuthToken):
                handler(.success(oAuthToken.access_token))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        currentTask?.resume()
    }
    
    private func makeRequest(code: String) -> URLRequest? {
        let url = URL(string: "https://unsplash.com/oauth/token")!
        var request = URLRequest(url: url)
        let params: [String: Any] = [
            "client_id": Constants.AccessKey,
            "client_secret": Constants.SecretKey,
            "redirect_uri": Constants.RedirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
        return request
    }
}

extension URLSession {
    
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnMainThread(.success(result))
                    } catch {
                        fulfillCompletionOnMainThread(.failure(error))
                    }
                } else {
                    fulfillCompletionOnMainThread(.failure(error!))
                    
                }
            } else if let error = error {
                fulfillCompletionOnMainThread(.failure(error))
            } else {
                fulfillCompletionOnMainThread(.failure(error!))
            }
        })
        return task
    }
}




