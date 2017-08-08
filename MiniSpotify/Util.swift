//
//  Util.swift
//  MiniSpotify
//
//  Created by Farbod Rafezy on 8/7/17.
//  Copyright © 2017 Farbod Rafezy. All rights reserved.
//

import Foundation

func httpRequest(to url: String, type: String, cb: @escaping (_ responseText: String) -> Void ){

    let requestUrl = URL(string: url)
    let request = NSMutableURLRequest(url: requestUrl!)
    request.httpMethod = type

    let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
        data, response, error in

        if error != nil {
            return print(error!)
        }

        print(response!)

        if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
            //
        }

        let responseText = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

        cb(responseText! as String)
    })

    task.resume()
}
