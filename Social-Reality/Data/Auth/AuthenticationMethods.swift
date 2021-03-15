//
//  AuthenticationMethods.swift
//  Social-Reality
//
//  Created by Nick Crews on 2/28/21.
//

import Foundation
import Amplify
import AmplifyPlugins
import GoogleSignIn
import FBSDKLoginKit
import AWSGoogleSignIn
import AWSUserPoolsSignIn
import GTMAppAuth
import AppAuth
import AuthenticationServices

// MARK: Authentication Methods - Global

struct Auth {
    
    var loggedIn: Bool {
        if Amplify.Auth.getCurrentUser() == nil {
            return false
        }
        return true
    }
    
    var user: AuthUser? {
        return Amplify.Auth.getCurrentUser()
    }
    
    func userAttributes(completion: @escaping(_ result: [String: String]?) -> Void) {
        Amplify.Auth.fetchUserAttributes { (result) in
            switch result {
            case .success(let authResult):
                print(authResult)
                var data: [String: String] = [:]
                for attribute in authResult {
                    data[attribute.key.rawValue] = attribute.value
                }
                completion(data)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    func checkSessionStatus(completion: @escaping(_ result: Bool) -> Void) {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
                completion(session.isSignedIn)
            case .failure(let error):
                print("Fetch session failed with error \(error)")
                completion(false)
            }
        }
    }
    
    func signInWithEmail(email: String, password: String, completion: @escaping(_ result: ResultType) -> Void) {
        if email.isValidEmail() {
            
        }
    }
    
    func userExists(email: String, completion: @escaping(_ result: Bool?) -> Void) {
        guard email.isValidEmail() else {
            print("Invalid Email", email)
            completion(nil)
            return
        }
        let userKeys = UserModel.keys
        let predicate = userKeys.email == email
        Query.api.get.usersWithPredicate(predicate: predicate) { (users) in
            if users?.count ?? 0 > 0 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func usernameExists(username: String, completion: @escaping(_ result: Bool) -> Void) {
        let userKeys = UserModel.keys
        let predicate = userKeys.username == username
        Query.api.get.usersWithPredicate(predicate: predicate) { (result) in
            if result == nil || result?.count ?? 0 > 0 {
                print("Username Taken")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func signUp(username: String, password: String, email: String, completion: @escaping(_ result: ResultType) -> Void) {
        guard email.isValidEmail() && password != "" else {
            completion(.error)
            return
        }
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                    completion(.success)
                } else {
                    print("SignUp Complete")
                    completion(.success)
                }
            case .failure(let error):
                completion(.success)
                print("An error occurred while registering a user \(error)")
            }
        }
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String, completion: @escaping(_ result: ResultType) -> Void) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success:
                print("Confirm signUp succeeded")
                completion(.success)
            case .failure(let error):
                print("An error occurred while confirming sign up \(error)")
                completion(.error)
            }
        }
    }
    
    func signInWithProvider(provider: AuthProvider, window: UIWindow, completion: @escaping(_ result: ResultType) -> Void) {
        Amplify.Auth.signInWithWebUI(for: provider, presentationAnchor: window, options: nil) { result in
            switch result {
            case .success:
                do {
                    let res = try result.get()
                    print(res.isSignedIn)
                    print(res.nextStep)
                    completion(.success)
                } catch {
                    print("error")
                    completion(.error)
                }
            case .failure(let error):
                print("Sign in failed \(error)")
                completion(.error)
            }
        }
    }
    
    
    func signIn(username: String, password: String, completion: @escaping(_ result: ResultType) -> Void) {
        guard username != "" else {
            completion(.error)
            return
        }
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success:
                print("Sign in succeeded")
                completion(.success)
            case .failure(let error):
                print("Sign in failed \(error)")
                completion(.error)
            }
        }
    }
    
    func rememberDevice(completion: @escaping(_ result: ResultType) -> Void) {
        Amplify.Auth.rememberDevice() { result in
            switch result {
            case .success:
                print("Remember device succeeded")
                completion(.success)
            case .failure(let error):
                print("Remember device failed with error \(error)")
                completion(.error)
            }
        }
    }
    
    func forgetDevice(completion: @escaping(_ result: ResultType) -> Void) {
        Amplify.Auth.forgetDevice() { result in
            switch result {
            case .success:
                print("Forget device succeeded")
                completion(.success)
            case .failure(let error):
                print("Forget device failed with error \(error)")
                completion(.error)
            }
        }
    }
    
    func fetchDevices(completion: @escaping(_ result: [AuthDevice]?) -> Void) {
        Amplify.Auth.fetchDevices() { result in
            switch result {
            case .success(let fetchDeviceResult):
                for device in fetchDeviceResult {
                    print(device.id)
                }
                completion(fetchDeviceResult)
            case .failure(let error):
                print("Fetch devices failed with error \(error)")
                completion(nil)
            }
        }
    }
    
    func signOutLocally(completion: @escaping(_ result: ResultType) -> Void) {
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                print("Successfully signed out")
                completion(.success)
            case .failure(let error):
                print("Sign out failed with error \(error)")
                completion(.error)
            }
        }
    }
    
    func signOutGloball(completion: @escaping(_ result: ResultType) -> Void) {
        Amplify.Auth.signOut(options: .init(globalSignOut: true)) { result in
            switch result {
            case .success:
                print("Successfully signed out")
                completion(.success)
            case .failure(let error):
                print("Sign out failed with error \(error)")
                completion(.error)
            }
        }
    }
    
}
