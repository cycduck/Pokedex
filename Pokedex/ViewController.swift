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
    
    func fetchDetail(pokemonURLList: [String], offset: Int) {
        
        
        for i in offset..<pokemonURLList.count {
            
            AF.request(pokemonURLList[i]).responseDecodable(of: PokemonDetailInfo.self) { response in
                print("calling \(pokemonURLList[i]) with index \(i)")

                guard let safeList = response.value else {
                    print("error retriving list")
                    return
                }
                
                self.paginatedList.append(safeList)
                
                print("L67 paginatedList.count \(self.paginatedList.count) pokemonListURLArr.count \(self.pokemonListURLArr.count)")
                // BUG: by the 3rd time paginatedList.count 60 pokemonListURLArr.count 40
                if self.paginatedList.count == self.pokemonListURLArr.count {
                    print("\(self.paginatedList.count) \(self.pokemonListURLArr.count)")

                    // sorting resource: http://studyswift.blogspot.com/2017/05/how-to-sort-array-and-dictionary.html
                    self.paginatedList.sort (by: {$0.id < $1.id})
                    
                    // maybe check if the cell is last in your code, so only reloads when the last cell is displayed
                    // you can do this by just keeping the index path in a "lastReloadedCell
                    print("L77 what is offset % 20 \(offset % 20) ")
                    if offset == 0 || offset % 20 == 0 {
                        print("L79 RELOADING... fetchlistcounter \(self.fetchlistCounter)")
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
        print(selected.name)
        
        //https://learnappmaking.com/pass-data-between-view-controllers-swift-how-to/
        // load view controller from storyboard, Main cuz Main.storyboard
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        // this matches the storyboard ID
        
        if let secondViewController = storyboard?.instantiateViewController(withIdentifier: "PokemonDetail") as? PokemonDetailViewController {
           // Pass Data
            secondViewController.dataStorageVariable = selected
           // Present Second View
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        print("\(indexPath.row + 1) == \(paginatedList.count) \((indexPath.row + 1) == paginatedList.count)")
        if (indexPath.row + 1) == paginatedList.count || indexPath.row + 1 > 39 {

            fetchList(offset: indexPath.row + 1)
        }
    }
}

