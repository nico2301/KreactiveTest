//
//  Result.swift
//  Kreactive
//
//  Created by perotin nicolas on 13/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

enum Result<T> {
    case success(T)
    case error(Error)
}
