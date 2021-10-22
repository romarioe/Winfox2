//
//  ThemeTableViewController.swift
//  Winfox2
//
//  Created by Roman Efimov on 21.10.2021.
//

import UIKit

class ThemeTableViewController: UITableViewController {
    

    let themeList = ["Авто",
                     "Бизнес",
                     "Инвестиции",
                     "Спорт",
                     "Саморазвитие",
                     "Здоровье",
                     "Еда",
                     "Семья, дети",
                     "Домашние питомцы",
                     "Фильмы",
                     "Компьютерные игры",
                     "Музыка"]
    
    var preferences: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    
    private func setupUI(){
        self.navigationItem.title = "Интересы"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath)
        cell.textLabel?.text = themeList[indexPath.row]
        
        if preferences.contains(themeList[indexPath.row]){
            cell.accessoryType = .checkmark
        }
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            preferences.removeAll(where: { $0 == tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "" })
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            preferences.append(tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
    
    

    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let destinationViewController = segue.destination as? ProfileViewController {
            destinationViewController.preferences = preferences  
        }
    }

}
