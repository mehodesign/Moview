//
//  MovieSearchViewModelTests.swift
//  MoviewTests
//
//  Created by Mehti Ozkan on 5.05.2021.
//

import XCTest
@testable import Moview


class MovieSearchViewModelTests: XCTestCase
{
    private let viewController = MockViewController()
    private let searchMoviesForNameService = MockSearchMoviesForNameService()

    func testing_movie_search_view_model_initializations()
    {
        let testViewModel = MovieSearchViewModel(with: viewController, service: searchMoviesForNameService)
        
        //Testing Initial Values
        XCTAssertTrue(testViewModel.searchString.value.isEmpty)
        XCTAssertFalse(testViewModel.canStartSearch.value)
        XCTAssertFalse(testViewModel.isSearching.value)
        XCTAssertEqual(testViewModel.searchResult.value.count, 0)
        
        //Testing Search String Update Case
        let testSearchString = "test movie name"
        testViewModel.searchString.accept(testSearchString)
        
        XCTAssertFalse(testViewModel.searchString.value.isEmpty)
        XCTAssertEqual(testViewModel.searchString.value, testSearchString)
        XCTAssertTrue(testViewModel.canStartSearch.value)
        
        //Testing Search String Cleaning Case
        testViewModel.searchString.accept("")
        XCTAssertTrue(testViewModel.searchString.value.isEmpty)
        XCTAssertFalse(testViewModel.canStartSearch.value)
    }

    func testing_movie_successful_movie_search()
    {
        let testViewModel = MovieSearchViewModel(with: viewController, service: searchMoviesForNameService)
        let movieName = "Matrix"
        
        testViewModel.searchString.accept(movieName)
        testViewModel.initiateMoviewSearch()
        
        let movieContent = MovieContent(title: "Matrix", year: "1999", genre: nil, duration: nil, plot: nil, id: nil, rating: nil, poster: nil)
        let searchResult = [movieContent]
        
        searchMoviesForNameService.downloadCompleted(success: true, result: searchResult)
        
        //Testing Search Results
        XCTAssertEqual(testViewModel.searchResult.value, searchResult)
        XCTAssertNil(viewController.errorTitle)
        XCTAssertNil(viewController.errorMessage)
    }
    
    func testing_failed_movie_searches()
    {
        let testViewModel = MovieSearchViewModel(with: viewController, service: searchMoviesForNameService)
        
        testViewModel.searchString.accept("Kiss")
        testViewModel.initiateMoviewSearch()
        
        let title = NSLocalizedString("Movie Not Found", comment: "")
        let message = NSLocalizedString("Please search another movie title", comment: "")
        
        searchMoviesForNameService.downloadCompleted(success: false, result: [])
        
        //Testing Failed Search Results
        XCTAssertNotNil(viewController.errorTitle)
        XCTAssertNotNil(viewController.errorMessage)
        XCTAssertEqual(viewController.errorTitle, title)
        XCTAssertEqual(viewController.errorMessage, message)
        
    }
    
    func testing_invalid_search_string()
    {
        let testViewModel = MovieSearchViewModel(with: viewController, service: searchMoviesForNameService)
        
        testViewModel.searchString.accept(" ")
        testViewModel.initiateMoviewSearch()
        
        let title = NSLocalizedString("Search Error", comment: "")
        let message = NSLocalizedString("Please enter a valid movie title to search.", comment: "")
        
        //Testing Failed Search Results
        XCTAssertNotNil(viewController.errorTitle)
        XCTAssertNotNil(viewController.errorMessage)
        XCTAssertEqual(viewController.errorTitle, title)
        XCTAssertEqual(viewController.errorMessage, message)
    }
}

private class MockViewController: MovieSearchScreen
{
    var errorTitle: String?
    var errorMessage: String?
    var movieDetailsToDisplay: MovieContent?
    
    func showSearchErrorAlertFor(title: String, message: String)
    {
        errorTitle = title
        errorMessage = message
    }
    
    func passToMovieDetailsScreenFor(movieContent: MovieContent)
    {
        movieDetailsToDisplay = movieContent
    }
}

private class MockSearchMoviesForNameService: SearchMoviesForNameService
{
    typealias SearchCompletion = (Bool, [MovieContent]) -> Void
    var storedCompletionBlock: SearchCompletion?
    
    override func searchMoviesFor(name: String, _ completion: @escaping SearchCompletion)
    {
        storedCompletionBlock = completion
    }
    
    func downloadCompleted(success: Bool, result: [MovieContent])
    {
        if storedCompletionBlock != nil
        {
            storedCompletionBlock!(success, result)
        }
    }
}
