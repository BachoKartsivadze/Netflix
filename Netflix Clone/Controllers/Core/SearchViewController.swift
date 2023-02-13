//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by bacho kartsivadze on 22.11.22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles = [Title]()
    
    private let searchTableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let conroller = UISearchController(searchResultsController: SearchResultsViewController())
        conroller.searchBar.placeholder = "Search for a Movie or a Tv show"
        conroller.searchBar.searchBarStyle = .minimal
        return conroller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(searchTableView)
        navigationItem.searchController = searchController
        
        
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        fetchData()
        
        searchController.searchResultsUpdater = self
        
    }
    
    
    private func fetchData() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier) as? TitleTableViewCell else{
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model = TitleViewModel(postURL: title.poster_path ?? "", movieTitle: title.original_title ?? title.original_name ?? "Unknown")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title else {return}
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case.success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    let model = TitlePreviewModel(title: titleName, overView: title.overview ?? "", video: videoElement)
                    vc.configure(with: model)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let currentSearchResults):
                    resultsController.titles = currentSearchResults
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func SearchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
