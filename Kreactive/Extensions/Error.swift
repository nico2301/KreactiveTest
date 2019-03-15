//
//  Error.swift
//  Kreactive
//
//  Created by perotin nicolas on 13/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import UIKit

extension Error{
    func isNetworkError() -> Bool{
        let code = (self as NSError).code
        return code == NSURLErrorTimedOut || code == NSURLErrorCannotConnectToHost
            || code == NSURLErrorNetworkConnectionLost || code == NSURLErrorNotConnectedToInternet
    }
}
