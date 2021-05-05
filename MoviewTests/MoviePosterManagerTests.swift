//
//  MoviePosterManagerTests.swift
//  MoviewTests
//
//  Created by Mehti Ozkan on 5.05.2021.
//

import XCTest
@testable import Moview

class MoviePosterManagerTests: XCTestCase
{
    private let moviePosterManager = MoviePosterManager.shared
    private let mockDownloadPosterService = MockDownloadPosterService()
    
    func testing_successful_poster_image_download()
    {
        moviePosterManager.setDonwloadService(service: mockDownloadPosterService)
        
        let imdbId = "1"
        let posterUrl = "testUrl"
        let testImage = UIImage()
        var downloadCompleted = false
            
        //Initiate Download
        moviePosterManager.downloadPosterForMovie(id: imdbId, posterUrl: posterUrl)
        { (success, id, image) in
            
            downloadCompleted = true
            XCTAssertTrue(success)
            XCTAssertNotNil(image)
            XCTAssertEqual(id, imdbId)
            XCTAssertEqual(image, testImage)
        }
        
        //Download Completes
        mockDownloadPosterService.downloadCompletedFor(path: posterUrl, success: true, image: testImage)
        
        XCTAssertTrue(downloadCompleted)
    }
    
    func testing_failed_poster_image_download()
    {
        moviePosterManager.setDonwloadService(service: mockDownloadPosterService)
        
        let imdbId = "2"
        let posterUrl = "testUrl"
        var downloadCompleted = false
        
        //Initiate Download
        moviePosterManager.downloadPosterForMovie(id: imdbId, posterUrl: posterUrl)
        { (success, id, image) in
            
            downloadCompleted = true
            XCTAssertFalse(success)
            XCTAssertNil(image)
            XCTAssertEqual(id, imdbId)
        }
        
        //Download Completes
        mockDownloadPosterService.downloadCompletedFor(path: posterUrl, success: false, image: nil)
        
        XCTAssertTrue(downloadCompleted)
    }
    
    func testing_unassigned_download_poster_image_service()
    {
        moviePosterManager.setDonwloadService(service: nil)
        
        var downloadDidFail = false
        
        moviePosterManager.downloadPosterForMovie(id: "1", posterUrl: "posterUrl")
        { (success, id, image) in
            
            downloadDidFail = !success
            XCTAssertFalse(success)
            XCTAssertNil(image)
        }
        
        XCTAssertTrue(downloadDidFail)
    }

    func testing_multiple_poster_image_downloads()
    {
        moviePosterManager.setDonwloadService(service: mockDownloadPosterService)
        
        let firstPosterId = "11"
        let firstPosterUrl = "firstPosterUrl"
        let firstTestImage = UIImage()
        
        let secondPosterId = "12"
        let secondPosterUrl = "secondPosterUrl"
        let secondTestImage = UIImage()
        
        var completedDownloads = 0
        
        //Initiate First Download
        moviePosterManager.downloadPosterForMovie(id: firstPosterId, posterUrl: firstPosterUrl)
        { (success, id, image) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(image)
            XCTAssertEqual(id, firstPosterId)
            XCTAssertEqual(image, firstTestImage)
            completedDownloads += 1
        }
        
        //Initiate Second Download
        moviePosterManager.downloadPosterForMovie(id: secondPosterId, posterUrl: secondPosterUrl)
        { (success, id, image) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(image)
            XCTAssertEqual(id, secondPosterId)
            XCTAssertEqual(image, secondTestImage)
            completedDownloads += 1
        }
        
        //First Download Completes
        mockDownloadPosterService.downloadCompletedFor(path: firstPosterUrl, success: true, image: firstTestImage)
        
        //Second Download Completes
        mockDownloadPosterService.downloadCompletedFor(path: secondPosterUrl, success: true, image: secondTestImage)
        
        //Testing Total Downloads
        XCTAssertEqual(completedDownloads, 2)
    }
    
    func testing_multiple_downloads_for_the_same_poster_image()
    {
        moviePosterManager.setDonwloadService(service: mockDownloadPosterService)
        
        let firstPosterId = "11"
        let firstPosterUrl = "firstPosterUrl"
        let firstTestImage = UIImage()
        var completedDownloads = 0
        
        //Initiate First Download
        moviePosterManager.downloadPosterForMovie(id: firstPosterId, posterUrl: firstPosterUrl)
        { (success, id, image) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(image)
            XCTAssertEqual(id, firstPosterId)
            XCTAssertEqual(image, firstTestImage)
            completedDownloads += 1
        }
        
        //Initiate Second Download
        moviePosterManager.downloadPosterForMovie(id: firstPosterId, posterUrl: firstPosterUrl)
        { (success, id, image) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(image)
            XCTAssertEqual(id, firstPosterId)
            XCTAssertEqual(image, firstTestImage)
            completedDownloads += 1
        }
        
        //First Download Completes
        mockDownloadPosterService.downloadCompletedFor(path: firstPosterUrl, success: true, image: firstTestImage)
        
        //Testing Total Downloads
        XCTAssertEqual(completedDownloads, 2)
    }
    
    func testing_already_downloaded_poster_image()
    {
        moviePosterManager.setDonwloadService(service: mockDownloadPosterService)
        
        let posterId = "1"
        let posterUrl = "testUrl"
        let testImage = UIImage()
        var completedDownloads = 0
        
        //Initiate Download
        moviePosterManager.downloadPosterForMovie(id: posterId, posterUrl: posterUrl)
        { (success, id, image) in
            completedDownloads += 1
        }
        
        //Download Completes
        mockDownloadPosterService.downloadCompletedFor(path: posterUrl, success: true, image: testImage)
        
        //Initiate Download Again
        moviePosterManager.downloadPosterForMovie(id: posterId, posterUrl: posterUrl)
        { (success, id, image) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(image)
            XCTAssertEqual(id, posterId)
            XCTAssertEqual(image, testImage)
            completedDownloads += 1
        }
        
        XCTAssertEqual(completedDownloads, 2)
    }
    
    func testing_maximum_downloaded_poster_image_functionality()
    {
        moviePosterManager.setDonwloadService(service: mockDownloadPosterService)
        
        //Download Poster Images More Times Than Maximum Storage Capacity
        let totalDownloads = (MoviePosterManager.MAX_STORED_IMAGES + 10)
        let downloadedPosterImage = UIImage()
        
        for counter in 0..<totalDownloads
        {
            let downloadId = "Id\(counter)"
            let posterUrl = "posterUrl\(counter)"
            
            //Start Downloading
            moviePosterManager.downloadPosterForMovie(id: downloadId, posterUrl: posterUrl)
            { (success, id, image) in
                
            }
            
            //Download Completes Successfully
            mockDownloadPosterService.downloadCompletedFor(path: posterUrl, success: true, image: downloadedPosterImage)
        }
        
        XCTAssertEqual(moviePosterManager.getAllMoviePosterImages().count, MoviePosterManager.MAX_STORED_IMAGES)
    }
}


private class MockDownloadPosterService: DownloadMoviePosterService
{
    typealias CompletionBlock = (Bool, UIImage?) -> Void
    
    private var donwloadListeners = [String: CompletionBlock]()
    
    override func getImageFromURL(path: String, _ completion: @escaping CompletionBlock)
    {
        donwloadListeners[path] = completion
    }
    
    public func downloadCompletedFor(path: String, success: Bool, image: UIImage?)
    {
        if let completion = donwloadListeners[path]
        {
            completion(success, image)
        }
    }
}
