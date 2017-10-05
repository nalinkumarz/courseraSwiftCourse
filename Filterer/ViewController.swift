//
//  ViewController.swift
//  Filterer
//
//  Created by Nalin Kumar on 4/09/16.
//  Copyright © 2016 Nalin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //@IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet var collectionViewContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var primaryMenu: UIView!
    @IBOutlet var sliderContainer: UIView!

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageButton: UIButton!
    
    var dataSource: DataSource?
    var filteredImage : UIImage?
    var filteredImageWithIntensity : UIImage?
    var originalImage : UIImage!
    var originalImageSelected = false
    let imageHelper  = ImageProcessorHelper(image : UIImage())
    var filteredValue: FilteredImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImage = UIImage.init(named: "sample")
        setButtonWithFadeWith(originalImage, state: UIControlState.Normal)
        self.imageButton?.clipsToBounds = true
        self.imageButton!.layer.cornerRadius = 10
        self.stackView.clipsToBounds = true
        self.stackView.layer.cornerRadius = 20
        
        dataSource = DataSource.init(image: originalImage)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        self.compareButton.enabled = false
        
        let alertController = UIAlertController(title: "Welcome to Filterer", message: "\nFilter Images with different effects\nEdit Filters\n\nCompare Images", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    //MARK view actions
    @IBAction func sliderTouchDown(sender: UISlider) {
        let intensity = Float(sender.value)
        
        guard filteredImage == nil && filteredValue == nil else {
            let intesityIncrease = intensity > self.filteredValue!.intensity ? true : false
            var imageToEdit = originalImage
            
            if(self.filteredImage != nil) {
                imageToEdit = self.filteredImage!
            }
            
            let image = self.imageHelper.apply((self.filteredValue!.filterType), toImage: imageToEdit, withIntensity: intensity, intensityIncreasing: intesityIncrease)
            self.imageButton.setBackgroundImage(image, forState: UIControlState.Normal)
            self.filteredImageWithIntensity = image
            self.filteredValue.intensity = intensity
            return
        }
    }
    
    @IBAction func imageTouched(sender: UIButton) {
        if (sender.tracking && !originalImageSelected) {
            setButtonWithFadeWith(originalImage, state: UIControlState.Highlighted)
            originalLabel.hidden = false
            self.compareButton.selected = false
        }
    }
    
    @IBAction func imageTouchReleased(sender: UIButton) {
        originalLabel.hidden = true
    }
    @IBAction func compareButtonAction(sender: UIButton) {
        if sender.selected {
            if self.filteredImage != nil {
                setButtonWithFadeWith(self.filteredImage!, state: UIControlState.Normal)
            } else if (self.filteredImageWithIntensity != nil) {
                setButtonWithFadeWith(self.filteredImageWithIntensity!, state: UIControlState.Normal)
            }
            self.originalLabel.hidden = true
            sender.selected = false
        } else {
            sender.selected = true
            self.originalLabel.hidden = false
            setButtonWithFadeWith(originalImage, state: UIControlState.Normal)
        }
    }
    @IBAction func filterButtonAction(sender: UIButton) {
        
        if sender.selected {
            hideSecondaryView(self.collectionViewContainer)
            hideSecondaryView(self.sliderContainer)
            self.editButton.enabled = false
            self.editButton.selected = false
            self.compareButton.enabled = false
            self.compareButton.selected = false
            sender.selected = false
            if filteredImageWithIntensity != nil {
                 setButtonWithFadeWith(self.filteredImageWithIntensity!, state: UIControlState.Normal)
            } else if filteredImage != nil {
                    setButtonWithFadeWith(filteredImage!, state: UIControlState.Normal)
            } else {
                    setButtonWithFadeWith(originalImage, state: UIControlState.Normal)
            }
        } else {
            editButton.selected = false
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    @IBAction func editButtonAction(sender: UIButton) {
        
        if sender.selected {
            self.hideSecondaryView(self.sliderContainer)
            sender.selected = false
            self.filterButton.selected = true
        } else {
            sender.selected = true
            filterButton.selected = false
            self.view.addSubview(self.sliderContainer)
            self.showViewWithConstriants(self.sliderContainer)
            UIView.animateWithDuration(0.4) {
                self.sliderContainer.alpha = 1
            }
        }

    }
    
    
    func setButtonWithFadeWith(image : UIImage, state: UIControlState) {
        self.imageButton.alpha = 0.6
        UIView.animateWithDuration(0.8) {
            self.imageButton.setBackgroundImage(image, forState: state)
            self.imageButton.alpha = 1
        }
    }
    
    func hideSecondaryView(view : UIView) {
        
        UIView.animateWithDuration(0.4, animations: { 
            view.alpha = 0
            }) { completed in
                if (completed) {
                    view.removeFromSuperview()
                }
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(collectionViewContainer)
        self.editButton.enabled = true
        
        self.showViewWithConstriants(self.collectionViewContainer)
        UIView.animateWithDuration(0.4) {
            self.collectionViewContainer.alpha = 1
            self.collectionView.reloadData()
        }
    }
    
    func showViewWithConstriants(viewWithConstaints : UIView) {
        viewWithConstaints.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint =  viewWithConstaints.bottomAnchor.constraintEqualToAnchor(primaryMenu.topAnchor)
        bottomConstraint.constant -= 10
        
        let leftConstraint = viewWithConstaints.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        
        let rightConstraint = viewWithConstaints.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = viewWithConstaints.heightAnchor.constraintEqualToConstant(60)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint,
            heightConstraint])
        
        view.layoutIfNeeded()
        
        viewWithConstaints.alpha = 0.0
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)  {
        if (indexPath.row == self.dataSource!.filteredImages.count - 1) {
            originalImageSelected = true
            self.imageButton.setBackgroundImage(originalImage, forState: UIControlState.Normal)
            self.filteredImage = nil
            self.filteredImageWithIntensity = nil
        } else {
            originalImageSelected = false
            filteredValue = dataSource!.getFilteredImageForIndex(indexPath.row) as FilteredImage!
            
            if (filteredValue.filterType == Filter.INVERT) {
                self.editButton.enabled = false
                self.editButton.selected = false
            } else {
                    self.editButton.enabled = true
            }
            
            var imageToFilter = self.imageHelper.apply(filteredValue.filterType, toImage: self.originalImage!, withIntensity: filteredValue.intensity, intensityIncreasing: false)
            if (self.filteredImageWithIntensity != nil) {
                  imageToFilter =   self.imageHelper.apply(filteredValue.filterType, toImage: self.filteredImageWithIntensity!, withIntensity: filteredValue.intensity, intensityIncreasing: false)
            } else if (self.filteredImage != nil) {
                imageToFilter =   self.imageHelper.apply(filteredValue.filterType, toImage: self.filteredImage!, withIntensity: filteredValue.intensity, intensityIncreasing: false)
            }
            

            setButtonWithFadeWith(imageToFilter, state: UIControlState.Normal)
            self.compareButton.enabled = true
            self.compareButton.selected = false
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource!.getFilteredImages().count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filtertedImageCell",forIndexPath:indexPath) as! FilteredImageCell
        let filteredValue = dataSource!.getFilteredImageForIndex(indexPath.row) as FilteredImage!
        cell.setImage(filteredValue.filteredImage)
        return cell
    }

}
