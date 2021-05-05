//
//  MovieDetailsViewModel.swift
//  Moview
//
//  Created by Mehti Ozkan on 4.05.2021.
//

import Foundation
import FirebaseAnalytics
import RxCocoa


protocol MovieDetailsScreen: class
{
    func showMovieContentAlertFor(title: String, message: String)
    func returnToPreviousScreen()
}

class MovieDetailsViewModel
{
    weak var movieDetailsScreen: MovieDetailsScreen?
    private var movieDetailsService: SearchMovieForIdService
    public private(set) var movieDetails: BehaviorRelay<MovieContent>
    
    public var isRequestingMovieDetails = BehaviorRelay(value: false)
    public var moviePosterImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    
    
    init(with view: MovieDetailsScreen, movie: MovieContent, service: SearchMovieForIdService)
    {
        movieDetailsScreen = view
        movieDetails = BehaviorRelay(value: movie)
        movieDetailsService = service
        
        getMovieDetials()
    }
    
    private func getMovieDetials()
    {
        isRequestingMovieDetails.accept(true)
        
        self.movieDetailsService.searchMovieFor(id: movieDetails.value.imdbId)
        { [weak self] (success, movieContent) in
            self?.isRequestingMovieDetails.accept(false)
            
            if let movie = movieContent
            {
                self?.movieDetails.accept(movie)
                self?.getPosterImage()
            }
            
            //Show Content Error
            if !success
            {
                let title = NSLocalizedString("Content Error", comment: "")
                let message = NSLocalizedString("Movie details could not loaded from server.", comment: "")
                self?.movieDetailsScreen?.showMovieContentAlertFor(title: title, message: message)
            }
            
            //Log Content to Firebase Analytics
            self?.logCurrentMovieDetails()
        }
    }
    
    private func getPosterImage()
    {
        if let posterUrl = movieDetails.value.posterImageUrl
        {
            MoviePosterManager.shared.downloadPosterForMovie(id: movieDetails.value.imdbId, posterUrl: posterUrl)
            { [weak self] (success, id, image) in
                if image != nil
                {
                    self?.moviePosterImage.accept(image!)
                }
            }
        }
    }
    
    private func logCurrentMovieDetails()
    {
        FirebaseAnalytics.Analytics.logEvent(AnalyticsEventViewSearchResults, parameters: [
            AnalyticsParameterItemName: movieDetails.value.movieTitle,
            AnalyticsParameterItemID: movieDetails.value.imdbId,
            AnalyticsParameterContentType: "MovieDetails",
            "year_of_release": movieDetails.value.yearOfRelease
        ])
    }
}
