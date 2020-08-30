import Foundation
import UIKit
import Alamofire
import AlamofireImage

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet var pokemonName: UILabel!
    @IBOutlet var pokemonIndex: UILabel!
    @IBOutlet var pokemonImage: UIImageView!
    @IBOutlet var pokemonText: UITextView!
    
    var dataStorageVariable: PokemonDetailInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let safeData = dataStorageVariable else { return }
        
        pokemonName.text = safeData.name.capitalized
        pokemonIndex.text = DataStylize.indexConvert(id: safeData.id)
        loadImage(imageURL: safeData.sprites.front_default)
        fetchDescription(id: safeData.id)
    }
    
    func loadImage(imageURL: URL) {
        AF.request(imageURL).responseImage { response in
            
            if case .success(let image) = response.result {
                self.pokemonImage.image = image
            }
        }
    }
    
    func fetchDescription(id: Int) {
        AF.request("https://pokeapi.co/api/v2/pokemon-species/\(id)/").responseDecodable(of: PokemonSpecies.self) { response in
            
            guard let safeData = response.value else {
                
                print("error retriving list")
                return
            }
            
            self.textConvert(flavoredText: safeData.flavor_text_entries[0].flavor_text)
        }
    }
    
    // https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
    func textConvert(flavoredText: String) {
        
        let range = NSRange(location: 0, length: flavoredText.utf16.count)
        
        let regex = try! NSRegularExpression(pattern: "(\\n|\\f)")
        
        let replacedText = regex.stringByReplacingMatches(in: flavoredText, options: [], range: range, withTemplate: " ")
        
        self.pokemonText.text = replacedText
    }
}
