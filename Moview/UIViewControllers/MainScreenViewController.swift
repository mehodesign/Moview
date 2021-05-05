//
//  MainScreenViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 7.04.2021.
//

import UIKit
import RxCocoa
import RxSwift


class MainScreenViewController: UtilitiesViewController, MovieSearchScreen, UITextFieldDelegate
{
    private let SEGUE_IDENTIFIER_MAIN_SCREEN_TO_DETAILS_SCREEN = "MainScreenToDetailsScreen"
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var searchResultTableView: UITableView!
    
    lazy private var viewModel = MovieSearchViewModel(with: self, service: SearchMoviesForNameService())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupUiBindings()
    }
    
    func setupUiBindings()
    {
        //Binding Search Text Field to Model
        let searchBinder: ControlProperty<String> = searchTextField.rx.text.orEmpty
        searchBinder
            .distinctUntilChanged()
            .bind(to: viewModel.searchString)
            .disposed(by: disposeBag)
        
        //Set Search Button State According to View Model
        _ = self.viewModel.canStartSearch
            .subscribe(onNext:
                        { [unowned self] in
                           let canSearch = $0
                           self.searchButton.isEnabled = canSearch })
            .disposed(by: disposeBag)
        
        //Show/Hide Activity Indicator Accordint to Search Status
        _ = self.viewModel.isSearching
            .distinctUntilChanged()
            .subscribe(onNext:
                        { [unowned self] in
                            $0 ? self.searchStarted() : self.hideProgressView()})
            .disposed(by: disposeBag)
        
        //Binding TableView to Search Results
        self.viewModel.searchResult
            .bind(to: self.searchResultTableView.rx.items(cellIdentifier: "MovieResultCell"))
            {(index, movie: MovieContent, cell) in
                if let searchResultCell = cell as? SearchDetailTableViewCell
                {
                    searchResultCell.setViewModel(SearchDetailsCellViewModel(with: searchResultCell, movie: movie))
                }
            }.disposed(by: disposeBag)
        
        //Show/Hide Table View According to Search Resul
        self.viewModel.searchResult
            .subscribe(onNext:
                        {[weak self] in
                            self?.searchResultTableView.isHidden = $0.isEmpty})
            .disposed(by: disposeBag)
        
        //Listen For Did Select Cell at Index Events
        self.searchResultTableView.rx.itemSelected
            .subscribe(onNext:
                        { [weak self] indexPath in
                            if let cell = self?.searchResultTableView.cellForRow(at: indexPath) as? SearchDetailTableViewCell
                            {
                                if let movie = cell.viewModel?.movieDetails
                                {
                                    self?.passToMovieDetailsScreenFor(movieContent: movie)
                                }
                            }
                        })
            .disposed(by: disposeBag)
    }
    
    func showSearchErrorAlertFor(title: String, message: String)
    {
        self.showAlertController(title: title, message: message, cancelButton: NSLocalizedString("OK", comment: ""))
    }
    
    func passToMovieDetailsScreenFor(movieContent: MovieContent)
    {
        self.performSegue(withIdentifier: self.SEGUE_IDENTIFIER_MAIN_SCREEN_TO_DETAILS_SCREEN, sender: movieContent)
    }
    
    func searchStarted()
    {
        self.searchTextField.resignFirstResponder()
        self.showProgressView()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let detailsViewController = segue.destination as? MovieDetailsViewController
        {
            if let selectedMovie = sender as? MovieContent
            {
                detailsViewController.setMovieDetailsViewModel(model: MovieDetailsViewModel(with: detailsViewController, movie: selectedMovie, service: SearchMovieForIdService()))
            }
        }
    }
    
    
    //MARK: - IBACtion Methods
    
    @IBAction func searchButtonPressAction(_ sender: Any)
    {
        self.viewModel.initiateMoviewSearch()
    }
    
    @IBAction func userTapToScreenGestureRecogniserAction(_ sender: Any)
    {
        searchTextField.resignFirstResponder()
    }
    
    
    //MARK: - Text field Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        searchButtonPressAction(searchButton as Any)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        self.viewModel.searchResult.accept([])
        textField.resignFirstResponder()
        return true
    }
}
