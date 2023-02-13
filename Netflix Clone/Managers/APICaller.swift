//
//  APICaller.swift
//  Netflix Clone
//
//  Created by bacho kartsivadze on 05.12.22.
//

import Foundation

struct constants {
    static let API_KEY = "ff977211893b542e5bf0f696c7b07556"
    static let youtubeAPI_KEY = "AIzaSyAFmpOL6poLIksq62wd-hRV5RZxcXAgegg"
    static let youtubeBase_URL = "https://youtube.googleapis.com/youtube/v3/search?"
}

class APICaller {
    static let shared = APICaller()
    
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=ff977211893b542e5bf0f696c7b07556") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/tv/day?api_key=ff977211893b542e5bf0f696c7b07556") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=ff977211893b542e5bf0f696c7b07556&language=en-US&page=1") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=ff977211893b542e5bf0f696c7b07556&language=en-US&page=1") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=ff977211893b542e5bf0f696c7b07556&language=en-US&page=1") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=ff977211893b542e5bf0f696c7b07556&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(constants.API_KEY)&query=\(query)") else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(TitleResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(constants.youtubeBase_URL)q=\(query)&key=\(constants.youtubeAPI_KEY)") else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(result.items[0]))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
