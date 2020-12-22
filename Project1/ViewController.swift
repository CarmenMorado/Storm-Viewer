//
//  ViewController.swift
//  Project1
//
//  Created by Carmen Morado on 10/6/20.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var pictures2 = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(suggest))
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
        performSelector(inBackground: #selector(loadImages), with: nil)
    }
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
            }
        }
        
        pictures2 = pictures
        pictures2.sort()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures2[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures2[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures2.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func suggest() {
        let shareLink = "Try it: https://github.com/CarmenMorado/StormViewer"
        let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    


}

