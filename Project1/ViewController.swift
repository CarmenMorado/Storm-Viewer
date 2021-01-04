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
    var pictDict = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(suggest))
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "pictDict") as? Data,
        let savedPictures = defaults.object(forKey: "pictures2") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictDict = try jsonDecoder.decode([String: Int].self, from: savedData)
                pictures2 = try jsonDecoder.decode([String].self, from: savedPictures)
            }
            
            catch {
                print("Failed to load saved data")
            }
        }
        
        performSelector(inBackground: #selector(loadImages), with: nil)
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
                pictDict[item] = 0
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
        let picture = pictures2[indexPath.row]
        cell.textLabel?.text = picture
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController{
            vc.selectedImage = pictures2[indexPath.row]
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures2.count
            navigationController?.pushViewController(vc, animated: true)
        }
        
        let picture = pictures2[indexPath.row]
        pictDict[picture]! += 1
        saveImageCount()
        print("Viewed \(picture) \(pictDict[picture]!) times.")
        tableView.reloadData()
    }
    
    func saveImageCount() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictDict),
        let savedPictures = try? jsonEncoder.encode(pictures2) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictDict")
            defaults.set(savedPictures, forKey: "pictures2")
        } else {
            print("Failed to save data.")
        }
    }
    
    @objc func suggest() {
        let shareLink = "Try it: https://github.com/CarmenMorado/StormViewer"
        let vc = UIActivityViewController(activityItems: [shareLink], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    


}

