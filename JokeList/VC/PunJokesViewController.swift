//
//  PunJokesViewController.swift
//  JokeList
//
//  Created by Oran on 19/07/2022.
//

import UIKit

class PunJokesViewController: UIViewController {
    
    var service = JokeListService.shard
    
    @IBOutlet weak var punTableView: UITableView!
    @IBOutlet weak var numberOfJokes: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        punTableView.dataSource = self
        numberOfJokes.text = "\(String(service.jokesArrayPun.count)) Jokes to Show:"
        load()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        load()
    }
    
    func load() {
        service.jokesArrayPun = []
        spinner.isHidden = false
        spinner.startAnimating()
        
        Task {
            if let image = await service.getImage(mainImage: service.joke_Image_Pun){
                self.mainImageView.image = image
                mainImageView.layer.cornerRadius = 40
            }
            await service.getManyJokes(category: service.joke_Url_Pun)
            spinner.stopAnimating()
            spinner.isHidden = true
            punTableView.reloadData()
            numberOfJokes.text = "\(String(service.jokesArrayPun.count)) Jokes to Show:"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailsViewController,
              let index = punTableView.indexPathForSelectedRow?.row
        else {
            return
        }
        detailViewController.selectJoke = service.jokesArrayPun[index]
    }
}

extension PunJokesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.jokesArrayPun.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = punTableView.dequeueReusableCell(withIdentifier: "punCell", for: indexPath) as! PunTableViewCell
        let item = service.jokesArrayPun[indexPath.row]
        cell.setupLabel.text = item.setup
        cell.deliveryLabel.text = item.delivery
        
        return cell
    }
}
