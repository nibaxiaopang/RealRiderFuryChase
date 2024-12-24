//
//  PuzzelsGameVC.swift
//  RealRiderFuryChase
//
//  Created by jin fu on 2024/12/24.
//


import UIKit

class RealRiderPuzzelsGameController: UIViewController {
    
    @IBOutlet weak var puzzelCollectionView: UICollectionView!
    @IBOutlet weak var levelsCollectionView: UICollectionView!
    
    
    @IBOutlet weak var levelsLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    
    // Currently selected level (update dynamically based on user selection)
    var selectedLevel: Int = 1
    
    // Array to hold randomized images for the selected level
    var randomizedImages: [String] = []
    var unlockedLevels: [Bool] = [true, false, false,false,false,false,false,false] // First level unlocked by default
    var turnCount: Int = 0
    var selectedIndexes: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        puzzelCollectionView.delegate = self
        puzzelCollectionView.dataSource = self
        levelsCollectionView.delegate = self
        levelsCollectionView.dataSource = self
        
        loadRandomizedImages()
        updateLabels()
    }
    
   
    func loadRandomizedImages() {
        if let puzzel = puzzels.first(where: { $0.level == selectedLevel }) {
            randomizedImages = puzzel.image.shuffled()
        }
    }
    
    func updateLabels() {
        levelsLabel.text = "Level: \(selectedLevel)"
        turnLabel.text = "Turns: \(turnCount)"
    }
    
    
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}


extension RealRiderPuzzelsGameController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == puzzelCollectionView {
            return randomizedImages.count
        } else if collectionView == levelsCollectionView {
            return puzzels.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == puzzelCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PuzzelCell", for: indexPath) as? RealRiderPuzzelCell else {
                return UICollectionViewCell()
            }
            
            let imageName = randomizedImages[indexPath.item]
            cell.imageView.image = UIImage(named: imageName)
            cell.srLabel.text = "\(indexPath.row + 1)"
            return cell
        } else if collectionView == levelsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath) as? RealRiderLevelCell else {
                return UICollectionViewCell()
            }
            
            let isUnlocked = unlockedLevels[indexPath.item]
            cell.imageView.image = UIImage(named: isUnlocked ? "unlocked" : "locked")
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == puzzelCollectionView {
            let div = CGFloat(randomizedImages.count)
            return CGSize(
                width: collectionView.frame.width / div - 2,
                height: collectionView.frame.height
            )
        } else if collectionView == levelsCollectionView {
            return CGSize(
                width: collectionView.frame.width / 4 - 10,
                height: collectionView.frame.height / 2 - 10
            )
        }
        return .zero
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == puzzelCollectionView {
            // Check if the turn count has reached 50
            if turnCount >= 10 {
                showTurnLimitReachedAlert()
                return
            }
            
            // Add the selected index to the array
            selectedIndexes.append(indexPath)
            
            if selectedIndexes.count == 2 {
                // Get the indices of the selected items
                let firstIndex = selectedIndexes[0].item
                let secondIndex = selectedIndexes[1].item
                
                // Swap the images in the randomizedImages array
                randomizedImages.swapAt(firstIndex, secondIndex)
                
                // Reload the affected items in the collection view
                puzzelCollectionView.reloadItems(at: selectedIndexes)
                
                // Increment the turn count
                turnCount += 1
                updateLabels()
                
                // Clear the selection array
                selectedIndexes.removeAll()
            }
            
            // Check if the images are in the correct order
            if randomizedImages == puzzels[selectedLevel - 1].image {
                // Play dumbing animation with CGAffineTransform
                UIView.animate(withDuration: 1.0, animations: {
                    self.puzzelCollectionView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // Zoom in
                }) { _ in
                    UIView.animate(withDuration: 1.0, animations: {
                        self.puzzelCollectionView.transform = .identity // Restore to original size
                    }) { _ in
                        // Delay for 2 seconds, then show level completed alert
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.showLevelCompletedAlert()
                        }
                    }
                }
            }
        } else if collectionView == levelsCollectionView {
            if unlockedLevels[indexPath.item] {
                selectedLevel = puzzels[indexPath.item].level
                loadRandomizedImages()
                turnCount = 0
                updateLabels()
                puzzelCollectionView.reloadData()
            }else{
                // Animate the locked cell to indicate it's not selectable
                if let cell = collectionView.cellForItem(at: indexPath) {
                    shakeAnimation(for: cell)
                }
            }
            
            
            
        }
    }
    
    func shakeAnimation(for view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-10, 10, -8, 8, -5, 5, 0] // Shaking pattern
        view.layer.add(animation, forKey: "shake")
    }
    
    func unlockNextLevel() {
        if selectedLevel < puzzels.count {
            unlockedLevels[selectedLevel] = true // Unlock the next level
            levelsCollectionView.reloadData()
            // Move to the next level automatically if needed
            selectedLevel += 1
            loadRandomizedImages()
            turnCount = 0
            updateLabels()
            puzzelCollectionView.reloadData()
        }
    }
    
    func showLevelCompletedAlert() {
        let alert = UIAlertController(
            title: "Level Completed!",
            message: "Congratulations! You've completed level \(selectedLevel). The next level will now unlock.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.unlockNextLevel()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showTurnLimitReachedAlert() {
        let alert = UIAlertController(
            title: "Turn Limit Reached",
            message: "You've reached the maximum allowed turns (50). Please restart the level or try again.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Restart Level", style: .default, handler: { _ in
            self.restartCurrentLevel()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func restartCurrentLevel() {
        // Reload the images for the current level
        loadRandomizedImages()
        
        // Reset the turn count
        turnCount = 0
        
        // Update the labels
        updateLabels()
        
        // Reload the collection view to reflect the reset state
        puzzelCollectionView.reloadData()
    }
    
    
    
}
