//
//  PreviousSearchResultsView.swift
//  Moview
//
//  Created by Mehti Ozkan on 8.04.2021.
//

import UIKit


protocol PreviousSearchResultsViewDelegate
{
    func userDidSelectSearchResult(selectedMovieContent: MovieContent)
}

class PreviousSearchResultsView: UIView, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var searchResultTableView: UITableView!
    
    private let PREVIOUS_SEARCH_RESULT_CELL_IDENTIFIER = "PreviousSearchResultCellIdentifier"
    
    private var previousSearchResults: [MovieContent] = []
    
    public var delegate: PreviousSearchResultsViewDelegate?

    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    public func setPreviousSearchResults(movieContents: [MovieContent]?)
    {
        if movieContents != nil
        {
            previousSearchResults = movieContents!
        }
        else
        {
            previousSearchResults = []
        }
        
        searchResultTableView.reloadData()
    }
    
    
    //MARK: - UITable View Data Source & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return previousSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var previousSearchresultCell = tableView.dequeueReusableCell(withIdentifier: PREVIOUS_SEARCH_RESULT_CELL_IDENTIFIER) as? SearchDetailTableViewCell
        
        if previousSearchresultCell == nil
        {
            previousSearchresultCell = (Bundle.main.loadNibNamed("SearchDetailTableViewCell", owner: self, options: nil)?.first as! SearchDetailTableViewCell)
        }
        
        let searchResult = previousSearchResults[indexPath.row]
        previousSearchresultCell!.setPreviousSearch(movieContent: searchResult)
        
        return previousSearchresultCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if delegate != nil
        {
            let searchResult = previousSearchResults[indexPath.row]
            delegate?.userDidSelectSearchResult(selectedMovieContent: searchResult)
        }
    }

}
