//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by bacho kartsivadze on 22.11.22.
//

import UIKit

enum Sections : Int {
    case TrandingMovies = 0
    case TrandingTvs = 1
    case Popuar = 2
    case Upcoming = 3
    case TopRated = 4
}


private var headerView: HeroImigeUIView?


class HomeViewController: UIViewController {
    
    let sectionTitles = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    
    let homeTableView = {
        let tableView = UITableView(frame: .zero, style: .grouped )
        tableView.backgroundColor = .red
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        homeTableView.backgroundColor = .systemBackground
        homeTableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        configureNavBar()
        
        configureHeaderView()
        homeTableView.tableHeaderView = headerView
        
        homeTableView.frame = view.bounds
        view.addSubview(homeTableView)
        
    }
    
    private func configureNavBar() {
        var imige = UIImage(named: "netflixLogo_Big")
        imige = imige?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: imige, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeaderView() {
        headerView = HeroImigeUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        APICaller.shared.getTrendingMovies {results in
            switch results {
            case.success(let titles):
                let selectedTitle = titles.randomElement()
                headerView?.configure(with: TitleViewModel(postURL: selectedTitle?.poster_path ?? "", movieTitle: selectedTitle?.original_title ?? ""))
            case.failure(let error):
                print(error)
            }
        }
    }
    
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewTableViewCell.identifier
        ) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self


        switch indexPath.section {
        case Sections.TrandingMovies.rawValue:

            APICaller.shared.getTrendingMovies { result in
                        switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error)
                        }
                    }

        case Sections.TrandingTvs.rawValue:

            APICaller.shared.getTrendingTvs { result in
                        switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error)
                        }
                    }

        case Sections.Popuar.rawValue:

            APICaller.shared.getPopular { result in
                        switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error)
                        }
                    }

        case Sections.Upcoming.rawValue:

            APICaller.shared.getUpcomingMovies { result in
                        switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error)
                        }
                    }

        case Sections.TopRated.rawValue:

            APICaller.shared.getTopRated { result in
                        switch result {
                        case .success(let titles):
                            cell.configure(with: titles)
                        case .failure(let error):
                            print(error)
                        }
                    }

        default:
            return UITableViewCell()
        }



        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffSet = view.safeAreaInsets.top
        let offSet = scrollView.contentOffset.y + defaultOffSet
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSet))
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(cell: CollectionViewTableViewCell, model: TitlePreviewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
