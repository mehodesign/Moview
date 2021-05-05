//
//  MoviePosterManager.swift
//  Moview
//
//  Created by Mehti Ozkan on 4.05.2021.
//

import Foundation
import UIKit


typealias DownloadListener = (_ success: Bool, _ id: String, _ image: UIImage?) -> Void

class MoviePosterManager
{
    static let MAX_STORED_IMAGES = 50
    
    static let shared = MoviePosterManager()
    
    private var downloadPosterService: DownloadMoviePosterService?
    private var posterStorages = [String: PosterStorage]()
    private var imageIdQueue = [String]()
    
    private init() { }
    
    public func setDonwloadService(service: DownloadMoviePosterService?)
    {
        self.downloadPosterService = service
    }
    
    public func getAllMoviePosterImages() -> [UIImage]
    {
        var posterImages = [UIImage]()
        posterStorages.values.forEach({ if let image = $0.posterImage {posterImages.append(image) }})
        return posterImages
    }
    
    public func downloadPosterForMovie(id: String, posterUrl: String, completion: @escaping DownloadListener)
    {
        //There is No Assigned Download Poster Service
        if self.downloadPosterService == nil
        {
            completion(false, id, nil)
            return
        }
        
        //Return Downloaded Poster Image
        if let image = posterStorages[id]?.posterImage
        {
            completion(true, id, image)
        }
        //Add to Waiting List of Poster Image Download
        else if posterStorages[id]?.downloadListeners != nil
        {
            posterStorages[id]?.downloadListeners.append(completion)
        }
        //Download Poster Image
        else
        {
            posterStorages[id] = PosterStorage(posterUrl: posterUrl, for:[completion])
            
            self.downloadPosterService!.getImageFromURL(path: posterUrl)
            { [weak self] (success, image) in
                if image != nil
                {
                    self?.posterStorages[id]?.posterImage = image
                    self?.imageIdQueue.append(id)
                    self?.checkStorageCapacity()
                }
                
                self?.notifyDowloadListenersFor(id: id, success: success)
            }
        }
    }
    
    private func notifyDowloadListenersFor(id: String, success: Bool)
    {
        if let listenerList = posterStorages[id]?.downloadListeners
        {
            let image = posterStorages[id]?.posterImage
            
            listenerList.forEach { (completion) in
                completion(success, id, image)
            }
            
            posterStorages[id]?.downloadListeners = []
        }
    }
    
    private func checkStorageCapacity()
    {
        if imageIdQueue.count > MoviePosterManager.MAX_STORED_IMAGES
        {
            let difference = imageIdQueue.count - MoviePosterManager.MAX_STORED_IMAGES
            
            for index in 0..<difference
            {
                posterStorages[imageIdQueue[index]] = nil
            }
            
            imageIdQueue = Array(imageIdQueue[difference..<imageIdQueue.count])
        }
    }
}

fileprivate struct PosterStorage
{
    let posterUrl: String
    var posterImage: UIImage?
    var downloadListeners = [DownloadListener]()
    
    init(posterUrl: String, for listeners: [DownloadListener]? = nil)
    {
        self.posterUrl = posterUrl
        self.downloadListeners.append(contentsOf: listeners ?? [])
    }
}
