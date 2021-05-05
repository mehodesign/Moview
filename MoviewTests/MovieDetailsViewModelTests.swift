//
//  MovieDetailsViewModelTests.swift
//  MoviewTests
//
//  Created by Mehti Ozkan on 5.05.2021.
//

import XCTest
@testable import Moview


class MovieDetailsViewModelTests: XCTestCase
{
    private let viewController = MockViewController()
    private let searchMoviesForIdService = MockSearchMovieForIdService()

    func testing_movie_details_view_model_initialization()
    {
        let partialMovieContent = MovieContent(title: "Matrix", year: "1999", genre: nil, duration: nil, plot: nil, id: nil, rating: nil, poster: nil)
        let testViewModel = MovieDetailsViewModel(with: viewController, movie: partialMovieContent, service: searchMoviesForIdService)
        
        XCTAssertTrue(testViewModel.isRequestingMovieDetails.value)
        XCTAssertNil(testViewModel.moviePosterImage.value)
        XCTAssertEqual(testViewModel.movieDetails.value, partialMovieContent)
    }
    
    func testing_successful_download_of_movie_details()
    {
        let partialMovieContent = MovieContent(title: "Matrix", year: "1999", genre: nil, duration: nil, plot: nil, id: nil, rating: nil, poster: nil)
        let testViewModel = MovieDetailsViewModel(with: viewController, movie: partialMovieContent, service: searchMoviesForIdService)
        
        XCTAssertTrue(testViewModel.isRequestingMovieDetails.value)
        
        let completeMovieContent = MovieContent(title: "Matrix", year: "1999", genre: "Action", duration: "120min", plot: "Neo, Morpheus and Trinity", id: "12345", rating: "8.9", poster: nil)
        
        searchMoviesForIdService.downloadComplete(success: true, movie: completeMovieContent)
        
        XCTAssertFalse(testViewModel.isRequestingMovieDetails.value)
        XCTAssertEqual(testViewModel.movieDetails.value, completeMovieContent)
        XCTAssertNil(viewController.errorTitle)
        XCTAssertNil(viewController.errorMessage)
    }
    
    func testing_failed_download_of_movie_details()
    {
        let partialMovieContent = MovieContent(title: "Matrix", year: "1999", genre: nil, duration: nil, plot: nil, id: nil, rating: nil, poster: nil)
        let testViewModel = MovieDetailsViewModel(with: viewController, movie: partialMovieContent, service: searchMoviesForIdService)
        
        XCTAssertTrue(testViewModel.isRequestingMovieDetails.value)
        XCTAssertNil(testViewModel.moviePosterImage.value)
        
        searchMoviesForIdService.downloadComplete(success: false, movie: nil)
        
        XCTAssertFalse(testViewModel.isRequestingMovieDetails.value)
        XCTAssertEqual(testViewModel.movieDetails.value, partialMovieContent)
        XCTAssertNotNil(viewController.errorTitle)
        XCTAssertNotNil(viewController.errorMessage)
        XCTAssertEqual(viewController.errorTitle, NSLocalizedString("Content Error", comment: ""))
        XCTAssertEqual(viewController.errorMessage, NSLocalizedString("Movie details could not loaded from server.", comment: ""))
    }
}


private class MockViewController: MovieDetailsScreen
{
    var errorTitle: String?
    var errorMessage: String?
    var returnToPreviousScreenCalled: Bool = false
    
    func showMovieContentAlertFor(title: String, message: String)
    {
        errorTitle = title
        errorMessage = message
    }
    
    func returnToPreviousScreen()
    {
        returnToPreviousScreenCalled = true
    }
}

private class MockSearchMovieForIdService: SearchMovieForIdService
{
    typealias SearchCompletion = (Bool, MovieContent?) -> Void
    var storedCompletion: SearchCompletion?
    
    override func searchMovieFor(id: String, _ completion: @escaping SearchCompletion)
    {
        self.storedCompletion = completion
    }
    
    func downloadComplete(success: Bool, movie: MovieContent?)
    {
        if storedCompletion != nil
        {
            storedCompletion!(success, movie)
        }
    }
}
