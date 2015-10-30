//
//  ViewController.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        SPBackgroundDownloader.downloader.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController : SPBackgroundDownloaderDelegate{
    private func setupDownloads(){
        self.statusLabel.text = "Starting download.."
        
        let item1 = ItemToDownloadInBackground(urlString: "http://flashair/DCIM/IMG_5153.jpg",
            fileToSaveURLString: "/Downloads/1/AllPhotos/IMG_5153.jpg")
        let item2 = ItemToDownloadInBackground(urlString: "http://flashair/DCIM/IMG_5154.jpg",
            fileToSaveURLString: "/Downloads/1/AllPhotos/IMG_5154.jpg")
        let item3 = ItemToDownloadInBackground(urlString: "http://flashair/DCIM/IMG_5155.jpg",
            fileToSaveURLString: "/Downloads/1/AllPhotos/IMG_5155.jpg")
        let item4 = ItemToDownloadInBackground(urlString: "http://flashair/DCIM/IMG_5159.jpg",
            fileToSaveURLString: "/Downloads/1/AllPhotos/IMG_5159.jpg")
        let item5 = ItemToDownloadInBackground(urlString: "http://flashair/DCIM/IMG_5157.jpg",
            fileToSaveURLString: "/Downloads/1/AllPhotos/IMG_5157.jpg")
        let item6 = ItemToDownloadInBackground(urlString: "http://flashair/DCIM/IMG_5158.jpg",
            fileToSaveURLString: "/Downloads/1/AllPhotos/IMG_5158.jpg")
        
        SPBackgroundDownloader.downloader.items = [item1,item2,item3,item4,item5,item6]
        
        SPBackgroundDownloader.downloader.session?.configuration.HTTPMaximumConnectionsPerHost = 1
        SPBackgroundDownloader.downloader.session?.configuration.timeoutIntervalForRequest = 300
        SPBackgroundDownloader.downloader.session?.configuration.timeoutIntervalForResource = 300
            
        SPBackgroundDownloader.downloader.startDownload()
    }
    
    func allDownloadCompleted() {
        self.statusLabel.text = "Download completed"
    }
    

    @IBAction func start(sender: AnyObject) {
        SPBackgroundDownloader.downloader.reset()
        setupDownloads()
    }
    
    @IBAction func crash(sender: AnyObject) {
        let array : [Int] = []
        print(array[0])
    }
}

