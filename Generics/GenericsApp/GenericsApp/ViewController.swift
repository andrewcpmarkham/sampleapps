//
//  ViewController.swift
//  GenericsApp
//
//  Created by Andrew CP Markham on 21/2/21.
//

import UIKit

class ViewController: UIViewController {
    
    var people = [Person]()
    
    private lazy var tableView: GenericTableView<Person, PersonCell> = {
        let v = GenericTableView<Person, PersonCell>( items: people) { (person, cell) in
            cell.person = person
        } selectionHandler: {(person) in
            print(person.name, person.gender)
        }
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPeople()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    /// Function to call the Star Wars API and retrieve data on people
    /// Who have the string 'sky' in there name
    /// This then populates the data storage for people and gets
    /// the data from the API for associated films
    func getPeople() {
        GenericNetworkManager<SWAPIEnvelope>().fetch(url: URL(string: "https://swapi.dev/api/people/?search=sky")!) { (results) in
            switch results {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(data ?? "---- NO DATA ----")
                
                if let people = data?.results{
                    self.people = people
                    self.tableView.reload(data: self.people)
                }
                self.getFilm(for: data?.results[0])
            }
        }
    }
    
    
    /// Function used to decode the film data that is stored
    /// against people as a string array when person data is
    /// returned from a Star Wars API call
    func getFilm(for person: Person?){
        guard let person = person else {
            return
        }
        
        GenericNetworkManager<Film>().fetch(url: URL(string: person.films[0])! ) { (results) in
            switch results {
            case .failure(let err):
                print(err)
            case .success(let film):
                print(film ?? "---- NO DATA ----")
            }
        }
    }
}

