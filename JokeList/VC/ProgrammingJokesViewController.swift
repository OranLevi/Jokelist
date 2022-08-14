//
//  ProgrammingJokesViewController.swift
//  JokeList
//
//  Created by Oran on 19/07/2022.
//

import UIKit

class ProgrammingJokesViewController: UIViewController {
    
    @IBOutlet weak var ProgrammingTableView: UITableView!
    @IBOutlet weak var numberOfJokes: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var service = JokeListService.shard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgrammingTableView.dataSource = self
        numberOfJokes.text = "\(String(service.jokesArrayProgramming.count)) Jokes to Show:"
        load()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        load()
    }
    
    func load(){
        service.jokesArrayProgramming = []
        spinner.isHidden = false
        spinner.startAnimating()
        
        Task {
            if let image = await service.getImage(mainImage: service.joke_Image_Programming){
                self.mainImageView.image = image
                mainImageView.layer.cornerRadius = 40
            }
            await service.getManyJokes(category: service.joke_Url_Programming)
            spinner.stopAnimating()
            spinner.isHidden = true
            ProgrammingTableView.reloadData()
            numberOfJokes.text = "\(String(service.jokesArrayProgramming.count)) Jokes to Show:"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailsViewController,
              let index = ProgrammingTableView.indexPathForSelectedRow?.row
        else {
            return
        }
        detailViewController.selectJoke = service.jokesArrayProgramming[index]
    }
}

extension ProgrammingJokesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.jokesArrayProgramming.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProgrammingTableView.dequeueReusableCell(withIdentifier: "ProgrammingCell", for: indexPath) as! ProgrammingTableViewCell
        let item = service.jokesArrayProgramming[indexPath.row]
        cell.setupLabel.text = item.setup
        cell.deliveryLabel.text = item.delivery
        
        return cell
    }
}
