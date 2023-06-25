//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by bacho kartsivadze on 22.11.22.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titles = [TitleItem]()
    
    private let downloadTableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadTableView)
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        
        fetchLocalStorageForDownload()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTableView.frame = view.bounds
    }
    
    
    private func fetchLocalStorageForDownload() {
        DBManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                self?.downloadTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}


extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier,for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let model = TitleViewModel(postURL: titles[indexPath.row].poster_path ?? "", movieTitle: titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "Unknown")
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DBManager.shared.deleteTitleWith(model: titles[indexPath.row]) {[weak self] result in
                switch result {
                case .success():
                    print("Deleted from the dataBase")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default: break
        }
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
