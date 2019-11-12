//
//  TagsViewController.swift
//  MemeGenie
//
//  Created by jovani Casarrubias on 11/12/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit

class TagsViewController: UITableViewController {

   let tags = ["Happy","Cringy","Sad","Romance","Dark Humor"]
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tags.count
        }
       
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = tags[indexPath.row]
            return cell
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            }
            else {
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        }
        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
        }
        
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
       

    }
