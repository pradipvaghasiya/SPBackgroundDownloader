//
//  SPBackgroundDownloader+File.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

private let kSPBackgroundDownloaderFolderName = "SPBackgroundDownloader"
extension SPBackgroundDownloader{
    func saveFile(task : NSURLSessionDownloadTask, downloadURL: NSURL) -> Bool{
        do{
            guard let originalHTTPURL = task.originalRequest?.URL else{
                return false
            }
            
            guard let toURL = documentsURLFromWebURL(originalHTTPURL) else{
                return false
            }
            
            try NSFileManager.defaultManager().copyItemAtURL(downloadURL, toURL: toURL, override: false)
            return true
        }catch{
//            print("Error while saving file \(task.taskIdentifier)")
        }
        return false
    }
    
    func fileExistsAtWebURL(url : NSURL) -> Bool{
        guard let path = documentsURLFromWebURL(url)?.path else{
            return false
        }
        
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    func documentsURLFromWebURL(url : NSURL) -> NSURL?{
        guard let webURLPath = url.urlIncludingHost()?.path else{
            return nil
        }
        
        guard let toURL = NSFileManager.defaultManager().documentsDirectory()?.URLByAppendingPathComponent(kSPBackgroundDownloaderFolderName).URLByAppendingPathComponent(webURLPath) else{
            return nil
        }
        
        return toURL
    }

    func deleteRootFolder(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)){
            let fileManager = NSFileManager.defaultManager()
            
            guard let url = fileManager.documentsDirectory()?.URLByAppendingPathComponent(kSPBackgroundDownloaderFolderName) else{
                return
            }
            
            do{
                try NSFileManager.defaultManager().removeItemAtURL(url)
            }catch{}
        }
    }
}