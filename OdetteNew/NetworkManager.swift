

//  NetworkManager.swift
//  OdetteNew
//
//  Created by Eugene Braginets on 18/10/15.
//  Copyright © 2015 Eugene Braginets. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation
import Haneke



enum APIRouter: URLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    public func asURLRequest() throws -> URLRequest {
        return URLRequest
    }

    static let BASE_URL = "http://odetteblum-api.xs2theworld.com"
    static let BASE_STATIC_URL = "http://odetteblum-cms.xs2theworld.com/static"
    
    case allCollections
    case collectionsById (Int)
    case imagesByTag (String)
    case allImages
    case tags

    
    var URLRequest: URLRequest {
        
        let (method): (Alamofire.Method) = {
            
            return .GET
            
        }()
        
        
        let (path) : (String) = {
            
            
            switch self {
                
            case .allCollections:
                return ("\(APIRouter.BASE_URL)/collections/all")

                
            case .collectionsById (let collectionId):
                return ("\(APIRouter.BASE_URL)/collections/\(collectionId)")
                
            case .imagesByTag (let tagname):
                let escapedAddress = tagname.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? ""
                return ("\(APIRouter.BASE_URL)/images/\(escapedAddress)")


            }
            
        }()
        let URL = Foundation.URL(string: path)
        
        let urlRequest = URLRequest(url: URL!)
        urlRequest.httpMethod = method.rawValue
        
        
        let encoding = Alamofire.ParameterEncoding.url
        
        return encoding.encode(urlRequest, parameters: nil).0
    }
   
}





class NetworkManager {
    
    var previousTask: URLSessionDataTask?
    static let sharedInstance = NetworkManager()
    init () {
        
    }
    
    
    
    class func getCollections(_ completionHandler: @escaping (NSError?, Array<Collection>?) -> ()) {
        
        let req = APIRouter.allCollections
        let manager = SessionManager()
        manager.request(req)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    if let result = response.result.value  {
                        
                        let json = JSON(result)
                        let collections = json["collections"].arrayValue
                        let collectionObjects = collections.map {
                            Collection(json: $0)
                        }
                        completionHandler(nil, collectionObjects)
                    } else {
                        completionHandler(nil, nil)
                    }
                    
                case .failure(let error):
                    //print ("error: \(error) on call: \(req.URLRequest.URLString)")
                    completionHandler (error as NSError?, nil)
                }
        }
        
    }
    
    class func getCollectionByID(_ collectionID: Int, completionHandler: @escaping (NSError?, Collection?) -> ()) {
        
        let req = APIRouter.collectionsById(collectionID)
        let manager = SessionManager()
        manager.request(req)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    if let result = response.result.value  {
                        let json = JSON(result)
                        let collectionObject = Collection(json: json)
                        
                        completionHandler(nil, collectionObject)
                    } else {
                        completionHandler(nil, nil)
                    }
                case .failure(let error):
                   // print ("error: \(error) on call: \(req.URLRequest.URLString)")
                    completionHandler (error as NSError?, nil)
                }
        }
    }
    
    class func getImagesByTag(_ tag: String, completionHandler: @escaping (NSError?, Array<Image>?) -> ()) {
        
        let req = APIRouter.imagesByTag(tag)
        let manager = SessionManager()
        manager.request(req)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    if let result = response.result.value  {
                        let json = JSON(result)
                        let images = json["images"].arrayValue
                        let imageObject = images.map {
                            Image(json: $0)
                        }
                        
                        completionHandler(nil, imageObject)
                    } else {
                        completionHandler(nil, nil)
                    }
                case .failure(let error):
                   // print ("error: \(error) on call: \(req.URLRequest.URLString)")
                    completionHandler (error as NSError?, nil)
                    
                }
        }
    }
    
    class func getAllImages(_ completionHandler: @escaping (NSError?, Array<Image>?) -> ()) {
        
        let req = APIRouter.allImages
        let manager = SessionManager()
        manager.request(req)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    if let result = response.result.value  {
                    let json = JSON(result)
                    let images = json["images"].arrayValue
                    let imageObject = images.map {
                    Image(json: $0)
                    }
                    
                    completionHandler(nil, imageObject)
                    } else {
                    completionHandler(nil, nil)
                    }
                case .failure(let error):
                 //   print ("error: \(error) on call: \(req.URLRequest.URLString)")
                    completionHandler (error as NSError?, nil)
                }
        }
        
    }
    
    
    class func getTags(_ completionHandler: @escaping (NSError?, Array<Tag>?) -> ()) {
        
        let req = APIRouter.tags
        let manager = SessionManager()
        manager.request(req)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    if let result = response.result.value  {
                        
                        let json = JSON(result)
                        let tags = json.arrayValue
                        let collectionObjects = tags.map {
                            Tag(json: $0)
                        }
                        
                        completionHandler(nil, collectionObjects)
                    } else {
                        completionHandler(nil, nil)
                    }
                    
                case .failure(let error):
                 //  print ("error: \(error) on call: \(req.URLRequest.URLString)")
                    completionHandler (error as NSError?, nil)
                    
                    
                    
                }
        }
    }
    
    
    class func loadImageFromURL (_ urlString: String, completionHandler: @escaping (String, UIImage?, NSError?) -> ()) {
        
        let url: URL! = URL(string: urlString)
        let session = URLSession.shared
        
        print ("image: \(urlString)")
        
        session.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            completionHandler(urlString, (data != nil) ? UIImage(data: data!) : nil, error)

            
        }).resume()
        
        
    }
    
    
    class func loadStaticImage (_ imageURL: String, completionHandler: @escaping (String, UIImage?, NSError?) -> ()) {
        
        let  req = APIRouter.staticImage(imageURL)
        
        let session = URLSession.shared
        let task = session.dataTask (with: req.URLRequest, completionHandler: {
            data, response, error in
            
            if data != nil, let image = UIImage(data: data!) {
                completionHandler(imageURL, image, error as NSError?)
            } else {
                completionHandler (imageURL, nil, error as NSError?)
            }
            
        })
        task.resume()
    }
        
    
    
    

}


