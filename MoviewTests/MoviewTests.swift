//
//  MoviewTests.swift
//  MoviewTests
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import XCTest
@testable import Moview


class MoviewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovieContentTitle()
    {
        //Testing Title String Equality
        let testTitleString = "Test Title"
        let testMovieContentTitle = MovieContent(title: testTitleString, year: "", genre: "", duration: "", plot: "", id: "", rating: "")
        XCTAssertEqual(testTitleString, testMovieContentTitle.movieTitle)
        
        //Testing Empty Title String
        let testMovieContentEmptyTitle = MovieContent(title: nil, year: "", genre: "", duration: "", plot: "", id: "", rating: "")
        XCTAssertNotNil(testMovieContentEmptyTitle.movieTitle)
        XCTAssertEqual(NSLocalizedString("No title", comment: ""), testMovieContentEmptyTitle.movieTitle)
        
        //Testing Title String With "N/A" Value
        let testMovieContentTitleNaValue = MovieContent(title: "N/A", year: "", genre: "", duration: "", plot: "", id: "", rating: "")
        XCTAssertEqual(NSLocalizedString("No title", comment: ""), testMovieContentTitleNaValue.movieTitle)
    }
    
    func testMovieContentYearOfRelese()
    {
        //Testing Year of Release String Equality
        let yearOfReleaseString = "1999"
        let testMovieContentTitle = MovieContent(title: "", year: yearOfReleaseString, genre: "", duration: "", plot: "", id: "", rating: "")
        XCTAssertEqual(yearOfReleaseString, testMovieContentTitle.yearOfRelease)
        
        //Testing Empty Year of Release String
        let testMovieContentEmptyTitle = MovieContent(title: "", year: nil, genre: "", duration: "", plot: "", id: "", rating: "")
        XCTAssertNotNil(testMovieContentEmptyTitle.yearOfRelease)
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentEmptyTitle.yearOfRelease)
        
        //Testing Year of Release String With "N/A" Value
        let testMovieContentTitleNaValue = MovieContent(title: "", year: "N/A", genre: "", duration: "", plot: "", id: "", rating: "")
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentTitleNaValue.yearOfRelease)
    }
    
    func testMovieContentGenre()
    {
        //Testing Genre String Equality
        let genreString = "Action"
        let testMovieContentTitle = MovieContent(title: "", year: "", genre: genreString, duration: "", plot: "", id: "", rating: "")
        XCTAssertEqual(genreString, testMovieContentTitle.genre)
        
        //Testing Empty Genre String
        let testMovieContentEmptyTitle = MovieContent(title: "", year: "", genre: nil, duration: "", plot: "", id: "", rating: "")
        XCTAssertNotNil(testMovieContentEmptyTitle.genre)
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentEmptyTitle.genre)
        
        //Testing Genre String With "N/A" Value
        let testMovieContentTitleNaValue = MovieContent(title: "", year: "", genre: "N/A", duration: "", plot: "", id: "", rating: "")
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentTitleNaValue.genre)
    }
    
    func testMovieContentMovieLength()
    {
        //Testing Movie Length Equality
        let movieLengthString = "120 min"
        let validationString = "120 " + NSLocalizedString("minutes", comment: "")
        let testMovieContentTitle = MovieContent(title: "", year: "", genre: "", duration: movieLengthString, plot: "", id: "", rating: "")
        XCTAssertEqual(validationString, testMovieContentTitle.lengthMinutes)
        
        //Testing Empty Movie Length String
        let testMovieContentEmptyTitle = MovieContent(title: "", year: "", genre: "", duration: nil, plot: "", id: "", rating: "")
        XCTAssertNotNil(testMovieContentEmptyTitle.lengthMinutes)
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentEmptyTitle.lengthMinutes)
        
        //Testing Movie Length String With "N/A" Value
        let testMovieContentTitleNaValue = MovieContent(title: "", year: "", genre: "", duration: "N/A", plot: "", id: "", rating: "")
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentTitleNaValue.lengthMinutes)
    }
    
    func testMovieContentShortPlot()
    {
        //Testing Movie Plot Equality
        let shortPlotString = "Movie Short Plot Test String"
        let testMovieContentTitle = MovieContent(title: "", year: "", genre: "", duration: "", plot: shortPlotString, id: "", rating: "")
        XCTAssertEqual(shortPlotString, testMovieContentTitle.shortPlot)
        
        //Testing Empty Plot String
        let testMovieContentEmptyTitle = MovieContent(title: "", year: "", genre: "", duration: "", plot: nil, id: "", rating: "")
        XCTAssertNotNil(testMovieContentEmptyTitle.shortPlot)
        XCTAssertEqual(NSLocalizedString("Unawailable", comment: ""), testMovieContentEmptyTitle.shortPlot)
        
        //Testing Plot String With "N/A" Value
        let testMovieContentTitleNaValue = MovieContent(title: "", year: "", genre: "", duration: "", plot: "N/A", id: "", rating: "")
        XCTAssertEqual(NSLocalizedString("Unawailable", comment: ""), testMovieContentTitleNaValue.shortPlot)
    }

    func testMovieContentImdbId()
    {
        //Testing IMDB ID String Equality
        let imdbIdString = "123456789"
        let testMovieContentTitle = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: imdbIdString, rating: "")
        XCTAssertEqual(imdbIdString, testMovieContentTitle.imdbId)
        
        //Testing Empty IMDB ID String
        let testMovieContentEmptyTitle = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: nil, rating: "")
        XCTAssertNotNil(testMovieContentEmptyTitle.imdbId)
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentEmptyTitle.imdbId)
        
        //Testing IMDB ID String With "N/A" Value
        let testMovieContentTitleNaValue = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "N/A", rating: "")
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentTitleNaValue.imdbId)
    }
    
    func testMovieContentImdbRatingScore()
    {
        //Testing IMDB Rrating Score Equality
        let imdbRatingString = "8.1"
        let testMovieContentTitle = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "", rating: imdbRatingString)
        XCTAssertEqual(imdbRatingString, testMovieContentTitle.imdbRating)
        
        //Testing Empty IMDB Rrating Score String
        let testMovieContentEmptyTitle = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "", rating: nil)
        XCTAssertNotNil(testMovieContentEmptyTitle.imdbRating)
        XCTAssertEqual(NSLocalizedString("Not Rated", comment: ""), testMovieContentEmptyTitle.imdbRating)
        
        //Testing IMDB Rrating Score String With "N/A" Value
        let testMovieContentTitleNaValue = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "", rating: "N/A")
        XCTAssertEqual(NSLocalizedString("Not Rated", comment: ""), testMovieContentTitleNaValue.imdbRating)
    }
    
}
