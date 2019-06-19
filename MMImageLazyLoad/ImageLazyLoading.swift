//
//  ImageLazyLoading.swift
//  TISource
//
//  Created by 1638995 on 13/05/19.
//  Copyright © 2019 TCSInterative. All rights reserved.
//

import UIKit

public class ImageLazyLoading: NSObject {
    
    /// This is used to run the operation is in Queue to rectify the UI Freeze
    private var operationQueue = OperationQueue()
    
    /**
     This download the images and return in the uimage in the completion handler
     
     - parameter urlStr: Provide the image url which we need to get the image from server
     
     - parameter placeHolderImage: Provide the Place-holder image for if customized image this is option parameter if we need then give the need image
     
     - parameter completion: this will return the image after the completion of image request or failure this will return the appropriate image
     
     */
    public func setImageFromUrl(urlStr: String, placeHolderImage:UIImage? = UIImage(named: "LoadingImage", in: Bundle(identifier: "org.cocoapods.MMImageLazyLoad"), compatibleWith: nil)  ?? UIImage(), completion: @escaping(UIImage)->()) {
        
        DispatchQueue.main.async {
            completion(placeHolderImage!)
        }
        let noImage = UIImage(named: "NoImage", in: Bundle(identifier: "org.cocoapods.MMImageLazyLoad"), compatibleWith: nil)  ?? UIImage()
        guard let url = URL(string: urlStr) else {
            DispatchQueue.main.async {
                completion(noImage)
            }
            return
        }
        let request = URLRequest.init(url: url)
        let session = URLSessionManager.sessionManager(withDelegate: self)
        operationQueue.addOperation {
            let sessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    DispatchQueue.main.async {
                        completion(noImage)
                    }
                    return
                }
                
                guard let dataValue = data else {
                    //check if the status code is still 200...300, because sometimes responses will return only a status code
                    DispatchQueue.main.async {
                        completion(noImage)
                    }
                    return
                }
                if 200...299 ~= statusCode {
                    DispatchQueue.main.async {
                        completion(UIImage.init(data: dataValue)!)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(noImage)
                    }
                }
            }
            sessionDataTask.resume()
            session.finishTasksAndInvalidate()
        }
    }
}

extension ImageLazyLoading: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if error != nil {
            print("\(error?.localizedDescription ?? "")")
        }
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust:challenge.protectionSpace.serverTrust!))
    }
    
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("Finished")
    }
}

class URLSessionManager:NSObject{
    /**
     This will retured the URL session with Session configuration
     -> default session configuration
     -> if the catch details are alreay available this will returned the same other wise download from server.
     */
    static func sessionManager(withDelegate delegate:URLSessionDelegate) -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let sessionManager = URLSession.init(configuration: configuration, delegate: delegate, delegateQueue: nil)
        return sessionManager
    }
}
