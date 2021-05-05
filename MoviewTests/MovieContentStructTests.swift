//
//  MoviewTests.swift
//  MoviewTests
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import XCTest
@testable import Moview


class MovieContentStructTests: XCTestCase
{
    func testing_movie_content_title()
    {
        //Testing Title String Equality
        let testTitleString = "Test Title"
        let testMovieContentTitle = MovieContent(title: testTitleString, year: "", genre: "", duration: "", plot: "", id: "", rating: "", poster: "")
        XCTAssertEqual(testTitleString, testMovieContentTitle.movieTitle)
        
        //Testing Empty Title String
        let testMovieContentEmptyTitle = MovieContent(title: nil, year: "", genre: "", duration: "", plot: "", id: "", rating: "", poster: "")
        XCTAssertNotNil(testMovieContentEmptyTitle.movieTitle)
        XCTAssertEqual(NSLocalizedString("No title", comment: ""), testMovieContentEmptyTitle.movieTitle)
        
        //Testing Title String With "N/A" Value
        let testMovieContentTitleNaValue = MovieContent(title: "N/A", year: "", genre: "", duration: "", plot: "", id: "", rating: "", poster: "")
        XCTAssertEqual(NSLocalizedString("No title", comment: ""), testMovieContentTitleNaValue.movieTitle)
    }
    
    func testing_movie_content_year_of_relese()
    {
        //Testing Year of Release String Equality
        let yearOfReleaseString = "1999"
        let testMovieContentYear = MovieContent(title: "", year: yearOfReleaseString, genre: "", duration: "", plot: "", id: "", rating: "", poster: "")
        XCTAssertEqual(yearOfReleaseString, testMovieContentYear.yearOfRelease)
        
        //Testing Empty Year of Release String
        let testMovieContentEmptyYear = MovieContent(title: "", year: nil, genre: "", duration: "", plot: "", id: "", rating: "", poster: "")
        XCTAssertNotNil(testMovieContentEmptyYear.yearOfRelease)
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentEmptyYear.yearOfRelease)
        
        //Testing Year of Release String With "N/A" Value
        let testMovieContentYearNaValue = MovieContent(title: "", year: "N/A", genre: "", duration: "", plot: "", id: "", rating: "", poster: "")
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentYearNaValue.yearOfRelease)
    }
    
    func testing_movie_content_genre()
    {
        //Testing Genre String Equality
        let genreString = "Action"
        let testMovieContentGenre = MovieContent(title: "", year: "", genre: genreString, duration: "", plot: "", id: "", rating: "", poster: "")
        XCTAssertEqual(genreString, testMovieContentGenre.genre)
        
        //Testing Empty Genre String
        let testMovieContentEmptyGenre = MovieContent(title: "", year: "", genre: nil, duration: "", plot: "", id: "", rating: "", poster: "")
        XCTAssertNotNil(testMovieContentEmptyGenre.genre)
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentEmptyGenre.genre)
        
        //Testing Genre String With "N/A" Value
        let testMovieContentGenreNaValue = MovieContent(title: "", year: "", genre: "N/A", duration: "", plot: "", id: "", rating: "", poster: "")
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentGenreNaValue.genre)
    }
    
    func testing_movie_content_movie_length()
    {
        //Testing Movie Length Equality
        let movieLengthString = "120 min"
        let validationString = "120 " + NSLocalizedString("minutes", comment: "")
        let testMovieContentDuration = MovieContent(title: "", year: "", genre: "", duration: movieLengthString, plot: "", id: "", rating: "", poster: "")
        XCTAssertEqual(validationString, testMovieContentDuration.lengthMinutes)
        
        //Testing Empty Movie Length String
        let testMovieContentEmptyDuration = MovieContent(title: "", year: "", genre: "", duration: nil, plot: "", id: "", rating: "", poster: "")
        XCTAssertNotNil(testMovieContentEmptyDuration.lengthMinutes)
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentEmptyDuration.lengthMinutes)
        
        //Testing Movie Length String With "N/A" Value
        let testMovieContentDurationNaValue = MovieContent(title: "", year: "", genre: "", duration: "N/A", plot: "", id: "", rating: "", poster: "")
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentDurationNaValue.lengthMinutes)
    }
    
    func testing_moviec_ontent_short_plot()
    {
        //Testing Movie Plot Equality
        let shortPlotString = "Movie Short Plot Test String"
        let testMovieContentShortPlot = MovieContent(title: "", year: "", genre: "", duration: "", plot: shortPlotString, id: "", rating: "", poster: "")
        XCTAssertEqual(shortPlotString, testMovieContentShortPlot.shortPlot)
        
        //Testing Empty Plot String
        let testMovieContentEmptyPlot = MovieContent(title: "", year: "", genre: "", duration: "", plot: nil, id: "", rating: "", poster: "")
        XCTAssertNotNil(testMovieContentEmptyPlot.shortPlot)
        XCTAssertEqual(NSLocalizedString("Unawailable", comment: ""), testMovieContentEmptyPlot.shortPlot)
        
        //Testing Plot String With "N/A" Value
        let testMovieContentShortPlotNaValue = MovieContent(title: "", year: "", genre: "", duration: "", plot: "N/A", id: "", rating: "", poster: "")
        XCTAssertEqual(NSLocalizedString("Unawailable", comment: ""), testMovieContentShortPlotNaValue.shortPlot)
    }

    func testing_movie_content_imdb_id()
    {
        //Testing IMDB ID String Equality
        let imdbIdString = "123456789"
        let testMovieContentImdbId = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: imdbIdString, rating: "", poster: "")
        XCTAssertEqual(imdbIdString, testMovieContentImdbId.imdbId)
        
        //Testing Empty IMDB ID String
        let testMovieContentEmptyImdbId = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: nil, rating: "", poster: "")
        XCTAssertNotNil(testMovieContentEmptyImdbId.imdbId)
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentEmptyImdbId.imdbId)
        
        //Testing IMDB ID String With "N/A" Value
        let testMovieContentImdbIdNaValue = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "N/A", rating: "", poster: "")
        XCTAssertEqual(NSLocalizedString("Unknown", comment: ""), testMovieContentImdbIdNaValue.imdbId)
    }
    
    func testing_movie_content_imdb_rating_score()
    {
        //Testing IMDB Rrating Score Equality
        let imdbRatingString = "8.1"
        let testMovieContentImdbRating = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "", rating: imdbRatingString, poster: "")
        XCTAssertEqual(imdbRatingString, testMovieContentImdbRating.imdbRating)
        
        //Testing Empty IMDB Rrating Score String
        let testMovieContentEmptyImdbRating = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "", rating: nil, poster: "")
        XCTAssertNotNil(testMovieContentEmptyImdbRating.imdbRating)
        XCTAssertEqual(NSLocalizedString("Not Rated", comment: ""), testMovieContentEmptyImdbRating.imdbRating)
        
        //Testing IMDB Rrating Score String With "N/A" Value
        let testMovieContentImdbRatingNaValue = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "", rating: "N/A", poster: "")
        XCTAssertEqual(NSLocalizedString("Not Rated", comment: ""), testMovieContentImdbRatingNaValue.imdbRating)
    }
    
    func testing_movie_content_poster_image_url()
    {
        let posterImageUrl = "www.test.posterIage.jpg"
        let testMovieContentPoster = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "", rating: "", poster: posterImageUrl)
        XCTAssertEqual(posterImageUrl, testMovieContentPoster.posterImageUrl)
        
        let testMovieContentEmptyPoster = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "", rating: "", poster: nil)
        XCTAssertNil(testMovieContentEmptyPoster.posterImageUrl)
        
        //Testing IMDB Rrating Score String With "N/A" Value
        let testMovieContentPosterNaValue = MovieContent(title: "", year: "", genre: "", duration: "", plot: "", id: "", rating: "", poster: "N/A")
        XCTAssertNil(testMovieContentPosterNaValue.posterImageUrl)
    }
}
