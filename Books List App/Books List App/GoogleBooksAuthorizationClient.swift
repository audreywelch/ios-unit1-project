
import Foundation
import GTMAppAuth // Library created by Google for authenticating their APIs

private let gtmAuthKeychainName = "Books-List-App-GTMAuthorization" // Change to my app name instead of "BooksAuth"
private let issuer = URL(string: "https://accounts.google.com")! // Don't change
private let bookScopeURL = URL(string: "https://www.googleapis.com/auth/books")! // Don't change

// Change to match my own Client ID
private let clientID = "317716817075-asi50jq4g9qs69g8ev63nhvvqp3q2q4s.apps.googleusercontent.com"
private let redirectURI = URL(string: "com.googleusercontent.apps.317716817075-asi50jq4g9qs69g8ev63nhvvqp3q2q4s:/oauthredirect")! // This is the client ID backward


final class GoogleBooksAuthorizationClient {
    
    // Shared instance because the authorization is something we want to apply accross the app
    static let shared = GoogleBooksAuthorizationClient()
    
    init() {
        loadGTMAuthState()
    }
    
    // Call to request authorization
    // We need to provide a UIViewController b/c this method presents UI/a web browser that allows the user to log into their Google account. Can't present UI without a view controller to anchor that to, pass in whatever view controller you are using
    // In this case, calling it from the Authorize method in my main view controller, which is just passing in self
    // General rule: whichever view controller you are authorizing from, you will pass in 'self'
    // Need a completion just in case there is an error when the user is trying to log in
    // Safe to call this method whenever the app is opened because if the user is already logged in, then it will just do nothing
    func authorizeIfNeeded(presenter: UIViewController, completion: @escaping (Error?) -> Void) {
        
        if let authState = authorization?.authState, authState.isAuthorized {
            // Already authorized, so no need to do it again.
            completion(nil)
            return
        }
        
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { (configuration, error) in
            if let error = error, configuration == nil {
                NSLog("Error retrieving discovery document: \(error)")
                return
            }
            guard let configuration = configuration else { return }
            
            // Create a request for authorization
            let authRequest = OIDAuthorizationRequest(configuration: configuration,
                                                      clientId: clientID,
                                                      scopes: [OIDScopeOpenID, OIDScopeProfile, bookScopeURL.absoluteString],
                                                      redirectURL: redirectURI,
                                                      responseType: OIDResponseTypeCode,
                                                      additionalParameters: nil)
            
            // Perform the request
            self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: authRequest, presenting: presenter) { (authState, error) in
                if let error = error, authState == nil {
                    NSLog("Authorization error: \(error)")
                    return
                }
                guard let authState = authState else {
                    self.authorization = nil
                    return
                }
                self.authorization = GTMAppAuthFetcherAuthorization(authState: authState)
            }
        }
    }
    
    // Give it a URL request that is already configured with a URL and a http Method
    // It takes the request, adds the authorization and info needed to tell the API that you have permission, and then calls the completion closure, and it provides another version of the same URLrequest you provided it, but it has added the authentication
    // Then you use THAT URLRequest to make your network request within the closure
    // If it fails you get an error, so handle those
    // If it succeeds you can actually do your network request with it
    func addAuthorization(to request: URLRequest, completion: @escaping (URLRequest?, Error?) -> Void) {
        
        let mutableRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        
        guard let auth = authorization else {
            NSLog("Need to authorize first")
            let error = NSError(domain: OIDOAuthAuthorizationErrorDomain, code: OIDErrorCodeOAuthAuthorization.unauthorizedClient.rawValue, userInfo: nil)
            completion(nil, error)
            return
        }
        
        auth.authorizeRequest(mutableRequest) { (error) in
            if let error = error {
                NSLog("Unable to authorize request: \(error)")
                completion(nil, error)
                return
            }
            
            let newRequest = (mutableRequest.copy() as! NSURLRequest) as URLRequest
            completion(newRequest, nil)
        }
    }
    
    // Used by app delegate
    func resumeAuthorizationFlow(with url: URL) -> Bool {
        guard let currentFlow = currentAuthorizationFlow else {
            return false
        }
        
        return currentFlow.resumeAuthorizationFlow(with: url)
    }
    
    // Here for testing
    // Call this to reset it, forget the authorization and remove it from keychain, then test it again
    func resetAuthorization() {
        authorization = nil
    }
    
    // MARK: - Private
    
    private func loadGTMAuthState() {
        authorization = GTMAppAuthFetcherAuthorization(fromKeychainForName: gtmAuthKeychainName)
    }
    
    private func saveGTMAuthState() {
        if let auth = authorization {
            GTMAppAuthFetcherAuthorization.save(auth, toKeychainForName: gtmAuthKeychainName)
        } else {
            GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: gtmAuthKeychainName)
        }
    }
    
    // MARK: - Properties
    
    var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    private(set) var authorization: GTMAppAuthFetcherAuthorization? {
        didSet {
            saveGTMAuthState()
        }
    }
    
}
