//
//  SearchDetailsCellViewModelTests.swift
//  MoviewTests
//
//  Created by Mehti Ozkan on 5.05.2021.
//

import XCTest
@testable import Moview

class SearchDetailsCellViewModelTests: XCTestCase
{
    private let cellViewController = MockSearchDetailsCell()
    private let mockDownloadPosterService = MockDownloadPosterService()
    private let moviePosterManager = MoviePosterManager.shared
    
    func testing_search_details_cell_view_model_initialization()
    {
        let movieContent = MovieContent(title: "Matrix", year: "1999", genre: "Action", duration: "120min", plot: "Neo, Morpheus and Trinity", id: "12345", rating: "8.9", poster: "posterUrl")
        let testCellViewModel = SearchDetailsCellViewModel(with: cellViewController, movie: movieContent)
        
        XCTAssertNotNil(testCellViewModel.movieDetails)
        XCTAssertEqual(testCellViewModel.movieDetails, movieContent)
    }
    
    func testing_successful_poster_image_download()
    {
        moviePosterManager.setDonwloadService(service: mockDownloadPosterService)
        
        let posterUrl = "successUrl"
        let movieContent = MovieContent(title: "Matrix", year: "1999", genre: "Action", duration: "120min", plot: "Neo, Morpheus and Trinity", id: "1", rating: "8.9", poster: posterUrl)
        let testCellViewModel = SearchDetailsCellViewModel(with: cellViewController, movie: movieContent)
        let testPosterImage = UIImage()
        
        mockDownloadPosterService.downloadCompletedFor(path: posterUrl, success: true, image: testPosterImage)
        
        XCTAssertNotNil(testCellViewModel.posterImage)
        XCTAssertEqual(testCellViewModel.posterImage, testPosterImage)
        XCTAssertEqual(cellViewController.downloadedPosterImage, testPosterImage)
    }
    
    func testing_failed_poster_image_download()
    {
        moviePosterManager.setDonwloadService(service: mockDownloadPosterService)
        
        let posterUrl = "failUrl"
        let movieContent = MovieContent(title: "Matrix", year: "1999", genre: "Action", duration: "120min", plot: "Neo, Morpheus and Trinity", id: "2", rating: "8.9", poster: posterUrl)
        let testCellViewModel = SearchDetailsCellViewModel(with: cellViewController, movie: movieContent)
        
        mockDownloadPosterService.downloadCompletedFor(path: posterUrl, success: false, image: nil)
        
        XCTAssertNil(testCellViewModel.posterImage)
        XCTAssertNil(cellViewController.downloadedPosterImage)
    }
}

private class MockSearchDetailsCell: SearchDetailsCell
{
    var downloadedPosterImage: UIImage?
    
    func posterImageDidUpdate(image: UIImage)
    {
        self.downloadedPosterImage = image
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
