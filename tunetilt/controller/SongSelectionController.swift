//
//  ViewController.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 15/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit

class SongSelectionController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Data fields
    var songs = [Song]()
    var selectedSong = Song()
    var displayPlayState: Bool = true
    var player: String?
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Sequences.plist")
    let storage = SongsStorage()
    
    // Outlet fields
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSwitch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Set up the table view for callbacks
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup the cell as reusable
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
      
        // Get and set the labels
        let songName: UILabel = cell.viewWithTag(3) as! UILabel
        let difficulty: UILabel = cell.viewWithTag(1) as! UILabel
        let playButton: UILabel = cell.viewWithTag(2) as! UILabel
        let item = songs[indexPath.row]
        songName.text = item.name
        difficulty.text = getDifficulty(for: item.notes)
      
        if (displayPlayState){
            playButton.text = "Play"
        }
        else{
            playButton.text = "Leaderboard"
        }
        
        return cell
    }
    
    @IBAction func unwind(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSong = songs[indexPath.row]
        if (!displayPlayState){
            performSegue(withIdentifier: "Leaderboard", sender: self)
        }
        else{
            performSegue(withIdentifier: "playGame", sender: self)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="Leaderboard"){
            guard let LeaderboardController = segue.destination as? LeaderboardController else { return }
            LeaderboardController.song = selectedSong.id
        }
        else{
            guard let GameController = segue.destination as? GameController else { return }
            GameController.song = selectedSong
            GameController.player = player
        }
        
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                songs = try decoder.decode([Song].self, from: data)
            }
            catch{
                print("Can't Load Data \(error)")
            }
        }
    }
    
    @IBAction func reloadData(_ sender: Any) {
        displayPlayState = !displayPlayState
        tableView.reloadData()
    }
    
    func getDifficulty(for sequence: [String]) -> String {
        switch sequence.count {
        case 0...4:
            return "Easy"
        case 5...8:
            return "Medium"
        case 8...12:
            return "Hard"
        case 8...Int.max:
            return "Very Hard"
        default:
            return "Unknown"
        }
    }
    
}

