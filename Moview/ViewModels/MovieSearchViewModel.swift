//
//  MainScreenViewModel.swift
//  Moview
//
//  Created by Mehti Ozkan on 3.05.2021.
//

import Foundation
import RxCocoa
import RxSwift


protocol MovieSearchScreen: class
{
    func showSearchErrorAlertFor(title: String, message: String)
    func passToMovieDetailsScreenFor(movieContent: MovieContent)
}


class MovieSearchViewModel
{
    private weak var view: MovieSearchScreen?
    private var searchMoviesForNameService: SearchMoviesForNameService
    private var disposeBag = DisposeBag()
    
    public var searchString = BehaviorRelay(value: "")
    public var canStartSearch = BehaviorRelay(value: false)
    public var isSearching = BehaviorRelay(value: false)
    public var searchResult = BehaviorRelay(value: [MovieContent]())
    
    init(with view: MovieSearchScreen, service: SearchMoviesForNameService)
    {
        self.view = view
        self.searchMoviesForNameService = service
        
        //Bind Search String to Can Search State
        _ = searchString
            .distinctUntilChanged()
            .map({$0.isValidSearchString()})
            .bind(to: canStartSearch)
            .disposed(by: disposeBag)
    }
    
    func initiateMoviewSearch()
    {
        self.isSearching.accept(true)
        
        //Start Searching Movies for Search String
        if searchString.value.isValidSearchString()
        {
            self.searchMoviesForNameService.searchMoviesFor(name: searchString.value)
            { [weak self]
                (success, movieList) in
                
                self?.isSearching.accept(false)
                self?.searchResult.accept(movieList)
                
                if !success
                {
                    let title = NSLocalizedString("Movie Not Found", comment: "")
                    let message = NSLocalizedString("Please search another movie title", comment: "")
                    self?.view?.showSearchErrorAlertFor(title: title, message: message)
                }
            }
        }
        else
        {
            let title = NSLocalizedString("Search Error", comment: "")
            let message = NSLocalizedString("Please enter a valid movie title to search.", comment: "")
            view?.showSearchErrorAlertFor(title: title, message: message)
        }
    }
}

fileprivate extension String
{
    func isValidSearchString() -> Bool
    {
        return (self.trimmingCharacters(in: .whitespacesAndNewlines).count > 0)
    }
}
