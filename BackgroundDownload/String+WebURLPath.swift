//
//  String+WebURLPath.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

extension String{
    func urlIncludingHost() -> NSURL?{
        guard let url = NSURL(string: self) else{
            return nil
        }
        
        guard let host = url.host else{
            return nil
        }
        
        guard let path = url.path else{
            return nil
        }
        
        return NSURL(string: host)?.URLByAppendingPathComponent(path)
    }
}