//
//  MovieDetailsViewController.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit
import RxCocoa
import RxSwift


class MovieDetailsViewController: UtilitiesViewController, MovieDetailsScreen
{
    @IBOutlet var moviePreviewImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearAndDurationLabel: UILabel!
    @IBOutlet var imdbScoreLabel: UILabel!
    @IBOutlet var imdbIdLabel: UILabel!
    @IBOutlet var plotTextLabel: UILabel!
    
    private var viewModel: MovieDetailsViewModel?
    private var disposeBag = DisposeBag()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if viewModel == nil
        {
            let title = NSLocalizedString("Content Error", comment: "")
            let message = NSLocalizedString("Movie content is corrupted, please try again", comment: "")
            self.showAlertController(title: title, message: message, cancelButton: NSLocalizedString("OK", comment: ""), cancelHandler:
                                        { [weak self] alert in
                                            self?.returnToPreviousScreen()
                                        })
        }
        else
        {
            setupUiBindings()
        }
    }
    
    public func setMovieDetailsViewModel(model: MovieDetailsViewModel)
    {
        viewModel = model
    }
    
    func setupUiBindings()
    {
        //Update UI
        if let viewModel = self.viewModel
        {
            //Update Movie Content Details
            viewModel.movieDetails
                .subscribe(onNext:
                            { [weak self] in
                                self?.updateMovieDetails(movieContent: $0)
                            })
                .disposed(by: disposeBag)
            
            //Show/Hide Activity Indicator
            viewModel.isRequestingMovieDetails
                .distinctUntilChanged()
                .subscribe(onNext:
                            { [weak self] in $0 ? self?.showProgressView() : self?.hideProgressView()})
                .disposed(by: disposeBag)
            
            //Set Poster Image
            viewModel.moviePosterImage
                .distinctUntilChanged()
                .bind(to: self.moviePreviewImage.rx.image )
                .disposed(by: disposeBag)
        }
    }
    
    func showMovieContentAlertFor(title: String, message: String)
    {
        self.showAlertController(title: title, message: message, cancelButton: NSLocalizedString("OK", comment: ""))
    }
    
    func returnToPreviousScreen()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateMovieDetails(movieContent: MovieContent)
    {
        titleLabel.text = movieContent.movieTitle
        genreLabel.text = movieContent.genre
        imdbScoreLabel.text = movieContent.imdbRating
        
        let yearText = NSLocalizedString("Year", comment: "") + ": " + movieContent.yearOfRelease
        let durationText = NSLocalizedString("Duration", comment: "") + ": " + movieContent.lengthMinutes
        yearAndDurationLabel.text = yearText + ", " + durationText
        
        imdbIdLabel.text = ("IMDB ID: " + movieContent.imdbId)
        
        plotTextLabel.text = movieContent.shortPlot
    }
    

    //MARK: - IBAction Methods
    
    @IBAction func backButtonPressAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
