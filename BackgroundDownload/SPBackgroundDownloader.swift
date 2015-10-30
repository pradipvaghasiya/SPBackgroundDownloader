//
//  SPBackgroundDownloader.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

let kSPBackgroundDownloaderSessionIdentifier = "com.speedui.SPBackgroundDownloader.Backgroundsessionidentifier"

typealias BackgroundSessionCompletionHandler = () -> Void
typealias GetTasksResult = ([NSURLSessionTask]) -> Void

class SPBackgroundDownloader : NSObject{
    
    static let downloader = SPBackgroundDownloader()
    var session : NSURLSession?
    
    var urlStrings : [String] = []
    weak var delegate : SPBackgroundDownloaderDelegate?
    
    struct Static{
        static var session : NSURLSession?
        static var token: dispatch_once_t = 0
    }

    override init() {
        super.init()
        session = backgroundSession()
    }
            
}


