//
//  MiscJokesViewController.swift
//  JokeList
//
//  Created by Oran on 19/07/2022.
//

import UIKit

class MiscJokesViewController: UIViewController {
    
    var service = JokeListService.shard
    
    @IBOutlet weak var miscTableView: UITableView!
    @IBOutlet weak var numberOfJokes: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        miscTableView.dataSource = self
        numberOfJokes.text = "\(String(service.jokesArrayMisc.count)) Jokes to Show:"
        load()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        load()
    }
    
    func load() {
        service.jokesArrayMisc = []
        spinner.isHidden = false
        spinner.startAnimating()
        
        Task {
            if let image = await service.getImage(mainImage: service.joke_Image_Misc){
                self.mainImageView.image = image
                mainImageView.layer.cornerRadius = 9
            }
            await service.getManyJokes(category: service.joke_Url_Misc)
            spinner.stopAnimating()
            spinner.isHidden = true
            miscTableView.reloadData()
            numberOfJokes.text = "\(String(service.jokesArrayMisc.count)) Jokes to Show:"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailsViewController,
              let index = miscTableView.indexPathForSelectedRow?.row
        else {
            return
        }
        detailViewController.selectJoke = service.jokesArrayMisc[index]
    }
    
}


extension MiscJokesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.jokesArrayMisc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = miscTableView.dequeueReusableCell(withIdentifier: "MiscCell", for: indexPath) as! MiscTableViewCell
        let item = service.jokesArrayMisc[indexPath.row]
        cell.setupLabel.text = item.setup
        cell.deliveryLabel.text = item.delivery
        
        return cell
    }
}

