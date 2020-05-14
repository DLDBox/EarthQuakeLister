//
//  QuakeListViewController.swift
//  DevoeQuakeLocator
//
//  Created by Dana Devoe on 5/13/20.
//  Copyright © 2020 Dana Devoe. All rights reserved.
//

import Foundation
import UIKit

class QuakeCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var magnitude: UILabel!
    @IBOutlet weak var time: UILabel!
    
}

/* Lists the Quake information in a tablevie and allow the user to selection a quake to get additional
 information */
class QuakeListViewController: DevoeViewController, UITableViewDelegate {
    
    //
    //MARK: - IBOutlet section
    //
    @IBOutlet weak var quakeList: UITableView!
    
    //
    //MARK: - private member section
    //
    let quakeDataSource = QuakeDataSource()
    var startTime: String { get { 
                    let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
                    return pastDate.toYYYYMMDD() }
        }
    var endTime: String { get { return Date().toYYYYMMDD() }} // set to todays date
    
    //
    //MARK: View life cycle
    //
    override func viewDidLoad() {
        quakeList.dataSource = self.quakeDataSource
        quakeList.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Load the quake data with no magnitude data
        self.quakeDataSource.loadQuakeData(startTime: self.startTime, endTime: self.endTime, magnitude: nil, completion: { success in
            DispatchQueue.main.async {
                self.quakeList.reloadData()
            }
        })
    }
 
    //
    //MARK: - UITableViewDelegate
    //
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = self.quakeDataSource.featureURLAt(indexPath) {
            self.performSegue( withIdentifier: "QuakeDetailSegue", sender: url )
        } else {
            print( "no url provided" )
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let urlString = sender as! String
        let quakeDetail: QuakeDetailViewController = segue.destination as! QuakeDetailViewController
        
        quakeDetail.loadWeb( urlString )
    }

}
