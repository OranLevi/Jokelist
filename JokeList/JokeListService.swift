//
//  JokeListService.swift
//  JokeList
//
//  Created by Oran on 19/07/2022.
//

import UIKit

// MARK: - Welcome
struct Welcome: Decodable {
    let category: String
    let type: String
    let setup: String
    let delivery: String
    let id: Int
}

class JokeListService {
    
    static let shard : JokeListService = JokeListService()
    
    // URL
    var joke_Url_Misc = "https://v2.jokeapi.dev/joke/Miscellaneous?type=twopart"
    var joke_Url_Programming = "https://v2.jokeapi.dev/joke/Programming?type=twopart"
    var joke_Url_Pun = "https://v2.jokeapi.dev/joke/Pun?type=twopart"
    var joke_Url_Dark = "https://v2.jokeapi.dev/joke/Dark?type=twopart"
    
    // Images
    var joke_Image_Misc = "https://cdn.pixabay.com/photo/2016/11/30/12/16/question-mark-1872665_1280.jpg"
    var joke_Image_Programming = "https://cdn.pixabay.com/photo/2016/11/23/14/45/coding-1853305_1280.jpg"
    var joke_Image_Pun = "https://cdn.pixabay.com/photo/2015/04/03/18/56/font-705667_1280.jpg"
    var joke_Image_Dark = "https://cdn.pixabay.com/photo/2018/09/30/16/29/smurf-3713846_1280.jpg"
    
    var jokesArrayMisc = [Welcome]()
    var jokesArrayProgramming = [Welcome]()
    var jokesArrayPun = [Welcome]()
    var jokesArrayDark = [Welcome]()
    
    var numberJokes = 19
    
    func getManyJokes(category: String) async {
        for _ in 0...numberJokes {
            if let joke = await getJoke(category: category){
                if category == joke_Url_Pun { self.jokesArrayPun.append(joke)}
                else if category == joke_Url_Dark {JokeListService.shard.jokesArrayDark.append(joke)}
                else if category == joke_Url_Programming { self.jokesArrayProgramming.append(joke)}
                else if category == joke_Url_Misc {JokeListService.shard.jokesArrayMisc.append(joke)}
            }
            if self.jokesArrayPun.count == self.numberJokes && self.jokesArrayDark.count == self.numberJokes && self.jokesArrayProgramming.count == self.numberJokes && self.jokesArrayMisc.count == self.numberJokes {
                return
            }
            
        }
    }
    
    func getJoke(category: String) async -> Welcome? {
        guard let urlString = URL(string: category) else {
            return nil
        }
        if let (data, _) = try? await URLSession.shared.data(from: urlString){
            do {
                let joke = try JSONDecoder().decode(Welcome.self, from: data)
                return joke
            } catch (let error){
                print("error \(error)")
                return nil
            }
        }
        return nil
    }
    
    func getImage(mainImage: String) async -> UIImage? {
        guard let mainImageURL = URL(string: mainImage) else {
            return nil
        }
        let (data, _) = try! await URLSession.shared.data(from: mainImageURL)
        if let image = UIImage(data: data) {
            return image
        } else {
            return nil
        }
    }
}

