//
//  NSURL+Path.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

extension NSURL{
    func urlIncludingHost() -> NSURL?{
        guard let host = host else{
            return nil
        }
        
        guard let path = path else{
            return nil
        }
        
        return NSURL(string: host)?.URLByAppendingPathComponent(path)
    }
}