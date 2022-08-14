//
//  DarkJokesViewController.swift
//  JokeList
//
//  Created by Oran on 19/07/2022.
//

import UIKit

class DarkJokesViewController: UIViewController {
    
    @IBOutlet weak var darkTableView: UITableView!
    @IBOutlet weak var numberOfJokes: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var service = JokeListService.shard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        darkTableView.dataSource = self
        numberOfJokes.text = "\(String(service.jokesArrayDark.count)) Jokes to Show:"
        load()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        load()
    }
    
    func load() {
        service.jokesArrayDark = []
        spinner.isHidden = false
        spinner.startAnimating()
        
        Task {
            if let image = await service.getImage(mainImage: service.joke_Image_Dark){
                self.mainImageView.image = image
                mainImageView.layer.cornerRadius = 40
            }
            await service.getManyJokes(category: service.joke_Url_Dark)
            spinner.stopAnimating()
            spinner.isHidden = true
            darkTableView.reloadData()
            numberOfJokes.text = "\(String(service.jokesArrayDark.count)) Jokes to Show:"
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailsViewController,
              let index = darkTableView.indexPathForSelectedRow?.row
        else {
            return
        }
        detailViewController.selectJoke = service.jokesArrayDark[index]
    }
}


extension DarkJokesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.jokesArrayDark.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = darkTableView.dequeueReusableCell(withIdentifier: "darkCell", for: indexPath) as! DarkTableViewCell
        let item = service.jokesArrayDark[indexPath.row]
        cell.setupLabel.text = item.setup
        cell.deliveryLabel.text = item.delivery
        
        return cell
    }
}
