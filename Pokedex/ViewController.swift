//
//  ViewController.swift
//  Pokedex
//
//  Created by Kelly Ho on 2020-08-20.
//  Copyright © 2020 Inc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    private var pokemonListURLArr: [String] = []
    var paginatedList: [PokemonDetailInfo] = []
    var text: String = ""
    var fetchlistCounter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchList(offset: 0)
    }
    
    // Retrieves a lit of URL appends to pokemonListURLArr []
    func fetchList(offset: Int) {
        
        fetchlistCounter += 1
    
        print("fetch list called \(fetchlistCounter)times .../pokemon?offset=\(offset + 20)&limit=20")
        let url = "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=20"
        
        AF.request(url).responseDecodable(of:PokemonListURLContainer.self) { response in
            
            guard let safeList = response.value else {
                
                print("error retriving list")
                return
            }

            for info in safeList.results {
                
                self.pokemonListURLArr.append(info.url)
            }
            
            self.fetchDetail(pokemonURLList: self.pokemonListURLArr, offset: offset)
        }
    }
    
    // For each of the URL inside pokemonListURLArr [], fetch data, put to paginatedList
    // offset is based on the number of cells in display, which is based on the paginatedList
    func fetchDetail(pokemonURLList: [String], offset: Int) {
        
        // pokemonListURLArr [] contains all URLs, must use the offset to avoid double entries
        for i in offset..<pokemonURLList.count {
            
            AF.request(pokemonURLList[i]).responseDecodable(of: PokemonDetailInfo.self) { response in

                guard let safeList = response.value else {
                    print("error retriving list")
                    return
                }
                
                self.paginatedList.append(safeList)
                
                if self.paginatedList.count == self.pokemonListURLArr.count {

                    // sorting resource: http://studyswift.blogspot.com/2017/05/how-to-sort-array-and-dictionary.html
                    self.paginatedList.sort (by: {$0.id < $1.id})
                    
                    if offset == 0 || offset % 20 == 0 {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginatedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PokemonCell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        let pokemonData = paginatedList[indexPath.row]
        // grabbing the data for the cell per item in the paginatedList
        
        cell.setPokemonList(data: pokemonData)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = paginatedList[indexPath.row]
        
        // https://medium.com/@emanharout/nifty-ways-of-passing-data-between-view-controllers-part-1-2-4d050d90b2e2	
        // https://learnappmaking.com/pass-data-between-view-controllers-swift-how-to/
        if let secondViewController = storyboard?.instantiateViewController(withIdentifier: "PokemonDetail") as? PokemonDetailViewController {
           // Pass Data
            secondViewController.dataStorageVariable = selected
           // Present Second View
            self.navigationController?.pushViewController(secondViewController, animated: true)
           // present(secondViewController, animated: true, completion: nil) // this eliminates the NC
        }
    }
    
    // https://stackoverflow.com/questions/39015228/detect-when-uitableview-has-scrolled-to-the-bottom	
    // https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614883-tableview
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        print("\(indexPath.row + 1) == \(paginatedList.count) \((indexPath.row + 1) == paginatedList.count)")
        if (indexPath.row + 1) == paginatedList.count {

            fetchList(offset: indexPath.row + 1)
        }
    }
}

