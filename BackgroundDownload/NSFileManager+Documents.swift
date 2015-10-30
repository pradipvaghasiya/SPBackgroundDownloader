//
//  NSFileManager+Documents.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

enum NSFileManagerError: ErrorType{
    case PathNotFound
    case FileNotCopied
}

extension NSFileManager{
    func documentsDirectory() -> NSURL?{
        let urls = URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)

        guard urls.count > 0 else{
            return nil
        }
        
        return urls[0]
    }
 
    func copyItemAtURL(srcURL: NSURL, toURL: NSURL, override : Bool) throws{
        guard let path = toURL.path else{
            throw NSFileManagerError.PathNotFound
        }
        
        guard let urlWithoutLastPath = toURL.URLByDeletingLastPathComponent else{
            return
        }
        
        try createDirectoryAtURL(urlWithoutLastPath, withIntermediateDirectories: true, attributes: nil)
        
        guard !override && fileExistsAtPath(path) else{
            try copyItemAtURL(srcURL, toURL: toURL)
            return
        }
        
        throw NSFileManagerError.FileNotCopied
    }

}