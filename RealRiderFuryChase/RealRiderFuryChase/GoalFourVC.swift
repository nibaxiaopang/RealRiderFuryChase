//
//  GoalFourVC.swift
//  RealRiderFuryChase
//
//  Created by jin fu on 2024/12/24.
//


import UIKit

class GoalFourVC: UIViewController {
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var flowLabel: UILabel!
    @IBOutlet weak var moveLable: UILabel!
    
    var grid: [[UIColor?]] = [] // 2D array to represent the grid
    let rows = 5
    let columns = 3
    let colors: [UIColor] = [.red, .blue] // Three colors
    var colorCounts: [UIColor: Int] = [.red: 5, .blue: 5,] // Count of each color
    var firstSelectedIndexPath: IndexPath? // To track the first selected cell
    
    var move : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        
        setupGrid()
        
        moveLable.text = "Moves : \(move)"
        flowLabel.text = "You try the Matched color!"
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func setupGrid() {
        // Create an array with five of each color
        var colorArray: [UIColor] = []
        for (color, count) in colorCounts {
            colorArray.append(contentsOf: Array(repeating: color, count: count))
        }
        
        // Shuffle the colors randomly
        colorArray.shuffle()
        
        // Initialize the grid
        grid = Array(repeating: Array(repeating: nil, count: columns), count: rows)
        
        var colorIndex = 0
        for row in 0..<rows {
            for col in 0..<columns {
                if col == columns - 1 { // Leave one column empty
                    continue
                }
                if colorIndex < colorArray.count {
                    grid[row][col] = colorArray[colorIndex]
                    colorIndex += 1
                }
            }
        }
        
        colorCollectionView.reloadData()
    }
    
    func getTopmostNonEmptyCell(in column: Int) -> Int? {
        // Get the row index of the topmost non-empty cell in the column (LIFO logic)
        for row in 0..<rows {
            if let _ = grid[row][column] {
                return row
            }
        }
        return nil
    }
    
    func getTopmostEmptyCell(in column: Int) -> Int? {
        // Get the row index of the topmost empty cell in the column
        for row in (0..<rows).reversed() {
            if grid[row][column] == nil {
                return row
            }
        }
        return nil
    }
    
    func checkWinCondition() -> Bool {
        // Check if each of the first three columns has all cells filled with the same color
        for col in 0..<columns - 1 {
            let firstColor = grid[0][col]
            if firstColor != nil && grid.allSatisfy({ $0[col] == firstColor }) {
                continue
            } else {
                return false
            }
        }
        return true
    }
    
    func showWinAlert() {
        let alert = UIAlertController(
            title: "You Win!",
            message: "All rows in three columns are filled with the same color.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in 
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension GoalFourVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.colorView.backgroundColor = grid[indexPath.section][indexPath.item] ?? .clear
        //cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 28
        let height = collectionView.frame.height / 5
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let firstIndex = firstSelectedIndexPath {
            // Second tap: Check if the tapped cell is in a valid column with an empty cell
            if firstIndex.item != indexPath.item, // Ensure the column is different
               let targetRow = getTopmostEmptyCell(in: indexPath.item) { // Check for topmost empty cell
                // Move the color to the topmost empty cell
                let colorToMove = grid[firstIndex.section][firstIndex.item]
                grid[firstIndex.section][firstIndex.item] = nil
                grid[targetRow][indexPath.item] = colorToMove
                
                // Clear the first selection
                firstSelectedIndexPath = nil
                
                // Reload the collection view
                colorCollectionView.reloadData()
                move += 1
                moveLable.text = "Moves : \(move)"
                // Check for win condition
                if checkWinCondition() {
                    flowLabel.text = "All rows in three columns are filled with the same color."
                    showWinAlert()
                }
            } else {
                // Invalid second tap, clear the first selection
                firstSelectedIndexPath = nil
                print("You must select a different column for the second tap.")
                flowLabel.text = "You must select a different column for the second tap."
            }
        } else {
            // First tap: Check if the selected cell has a color
            if let color = grid[indexPath.section][indexPath.item] {
                // Allow selection only if this is the topmost non-empty cell in the column
                if let topmostRow = getTopmostNonEmptyCell(in: indexPath.item), topmostRow == indexPath.section {
                    firstSelectedIndexPath = indexPath // Save the first selection
                } else {
                    // Invalid selection, do nothing
                    print("You can only select the topmost non-empty cell in a column.")
                    
                    flowLabel.text = "You can only select the topmost non-empty cell in a column."
                }
            }
        }
    }
}