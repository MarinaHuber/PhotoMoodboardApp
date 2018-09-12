//
//  MoodbordDesktopVC.swift
//  OdetteNew
//
//  Created by Marina Huber on 29/04/16.
//  Copyright © 2016 xs2. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}




//MARK: Wrapper for UI


class ItemDisplay: UIImageView {
    
    //this constant defines maximum size of the moodboard item related to the default size
    let MAX_SCALE: Float = 15.5
    
    class var defaultMoodBoardSize: CGSize {
        get {
            let isPad = UIDevice().userInterfaceIdiom  == .pad
            return isPad ? CGSize(width: 250, height: 250) : CGSize(width: 150, height: 150)
        }
    }
    
    var item: MoodboardItem? = nil
    
    
    
    convenience init (moodBoardItem: MoodboardItem) {
        
        self.init(frame:  CGRect(x: 0, y: 0, width: ItemDisplay.defaultMoodBoardSize.width, height: ItemDisplay.defaultMoodBoardSize.height))
            
        self.isUserInteractionEnabled = true
        self.item = moodBoardItem
        
        //default setup
        contentMode = .scaleAspectFit
        layer.shadowOffset = CGSize(width: 0,height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2.0
        
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        
        
        self.transform = moodBoardItem.transform
        
    }
    
    func save(_ withIndex: Int) {
        
        item?.transform = self.transform
        item?.zIndex = withIndex
        item?.update()
    }
    
    
    func isZoomingAlowed (_ scale: CGFloat) -> Bool {
        
        //new transform
        let t = transform.scaledBy(x: scale, y: scale)
        //new size
        let newSize = frame.size.applying(t)
        
        //new diagonal
        let rNew = sqrtf((Float) (newSize.width * newSize.width + newSize.height * newSize.height))
        
        //get max allowed diagonal
        let defaultSize = ItemDisplay.defaultMoodBoardSize
        let rDefault = sqrtf((Float) (defaultSize.width * defaultSize.width + defaultSize.height * defaultSize.height))
        let rMax = rDefault * MAX_SCALE
        
        return rNew < rMax
    }
    
    
}




class MoodboardDesktopVC: UIViewController {
    
    @IBOutlet weak var emptyText: UILabel!
    @IBOutlet weak var viewEmptyState: UIView!
    var transform: CGAffineTransform = CGAffineTransform()
    @IBOutlet weak var choosePictureText: UILabel!
    @IBOutlet weak var desktop: UIView!
    
    @IBOutlet weak var viewDeleteArea: UIView!
    var currentVC: UIViewController?
    var images: Array<ItemDisplay> = []
    var TrashcanOpen: Bool = Bool()
    
    @IBOutlet weak var lidTrash: UIImageView!
    @IBOutlet weak var bottomTrash: UIImageView!
    
    @IBOutlet weak var watermarkBanner: UIView!
    @IBOutlet weak var watermarkLogo: UIImageView!
   // @IBOutlet weak var watermarkTxt: UILabel!
    
    var trashCanTimer: Timer?
    
    
    //MARK: - UIViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isPad = UIDevice().userInterfaceIdiom  == .pad
        choosePictureText.font = isPad ? UIFont(name: "Servetica-Thin", size: 36) : UIFont(name: "Servetica-Thin", size: 22)
        self.lidTrash.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        self.bottomTrash.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        UIView.setAnchorPoint(CGPoint(x: 1, y: 0.5), forView: self.lidTrash)
        
        showTrashCan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = UIRectEdge()
        desktop.backgroundColor = Colors.lightGray
        //watermarkBanner.hidden = true
        self.reloadImages()
       
        

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveOnscreenMoodBoardItems()
        self.lidTrash.alpha = 1
        self.bottomTrash.alpha = 1
        
      }
    
    func saveOnscreenMoodBoardItems() {
        for i in 0..<desktop.subviews.count {
            let v = desktop.subviews[i]
            if let item = v as? ItemDisplay {
                item.save(i)
            }
            
        }
    }
    
    func reloadImages() {
        
       _ = desktop.subviews.map {
            if let v = $0 as? ItemDisplay {
                v.removeFromSuperview()
            }
        }
        
        images = DataManager.getMoodBoardItems().map {
            print ("\($0.imageMoodboard.imageName), zIndex: \($0.zIndex)")
       
            var item = $0
            item.transform = (CGAffineTransformEqualToTransform($0.transform, CGAffineTransform.identity)) ? getRandomTransform() : $0.transform
          //  print("transform all: \(item.transform)")
            return ItemDisplay(moodBoardItem: item)
            }
            .sorted(by: {
                $0.0.item?.zIndex < $0.1.item?.zIndex
            })
        
        
        if (images.count > 0) {
            setMoodBoard()
            viewEmptyState.isHidden = true
        } else {
            viewEmptyState.isHidden = false
        }
        
        
    }
    
    
    
    //MARK: - CGAffineTransformations
    
    func getRandomTransform() -> CGAffineTransform {
        


        //create a range for a diagobal size of item
        //Diagonal	=	 √	w2 	+ h2
        //var diagonal = sqrt(itemWidth * itemWidth + itemHeight * itemHeight)
        //let picture = self.view
        
        
        //let transformedBounds: CGRect = CGRectApplyAffineTransform(picture.bounds, picture.transform)

       
        var transform = CGAffineTransform.identity
        
        let screenWidth = self.desktop.frame.size.width
        let screenHeight = self.desktop.frame.size.height
        
        
        let positionRange: CGSize = CGSize(width: 0.6, height: 0.6)
        let positionStart = CGPoint(x: 0.0, y: 0.0)
        
        
        let positionRangePixels: CGSize = CGSize(width: positionRange.width * screenWidth, height: positionRange.height * screenHeight)
        let positionStartPixels: CGPoint = CGPoint(x: positionStart.x * screenWidth, y: positionStart.y * screenHeight)
        
        
        let randomDistanceX = CGFloat(arc4random_uniform(UInt32(positionRangePixels.width)))
        let randomDistanceY = CGFloat(arc4random_uniform(UInt32(positionRangePixels.height)))
        let randomPoint = CGPoint(x: positionStartPixels.x + randomDistanceX, y: positionStartPixels.y + randomDistanceY)
        
        //Scale randomize
        let scaleLevel: CGFloat = 0.5
        let randomScale = (1 - scaleLevel / 2.0) + CGFloat(arc4random_uniform(UInt32(scaleLevel * 100.0))) / 100.0
        
        
        //Angle randomize
        
        let angleRange = 2.0
        let randomAngle = Double(arc4random_uniform(UInt32(angleRange)))
        let angle = (-angleRange / 2.0) + randomAngle
        
        //Position randomize apply
        let t1 = transform.translatedBy(x: randomPoint.x, y: randomPoint.y)
        
        
        //Angle randomize apply from center
        let t0 = CGAffineTransform(rotationAngle: CGFloat(angle))
        
        transform = t0.concatenating(t1)
        
        

        
        //Scale randomize apply
        transform = transform.scaledBy(x: randomScale, y: randomScale)
        
        return transform
        
    }
    
    func setMoodBoard() {
        
        
        //apply gestures and add a subview
        _ = images.map{
            
            let pinchRec = UIPinchGestureRecognizer()
            let rotateRec = UIRotationGestureRecognizer()
            let panRec = UIPanGestureRecognizer()
            let tapRec = UITapGestureRecognizer()
            
            rotateRec.addTarget(self, action: #selector(MoodboardDesktopVC.rotatedView(_:)))
            $0.addGestureRecognizer(rotateRec)
            panRec.addTarget(self, action: #selector(MoodboardDesktopVC.draggedView(_:)))
            $0.addGestureRecognizer(panRec)
            tapRec.addTarget(self, action: #selector(MoodboardDesktopVC.tappedView))
            $0.addGestureRecognizer(tapRec)
            pinchRec.addTarget(self, action: #selector(MoodboardDesktopVC.pinchedView(_:)))
            $0.addGestureRecognizer(pinchRec)
            
            $0.loadImageFromOdetteImage($0.item?.imageMoodboard, size: .original)

            self.desktop.addSubview($0)

            
            //*******************************
            // loading animation UIImageView
            //*******************************
            DispatchQueue.main.async(execute: { () -> Void in
     
            self.animateStart(1.0, delay: 0.0, completion:  {
                completed in

                self.view.layoutIfNeeded()
            })


                
            })

            
        }
      
        
    }
    
    
    
    func animateStart(_ duration: TimeInterval, delay: TimeInterval, completion: @escaping ((Bool) -> Void)) {
        _ = images.enumerated().map{
            let item = $1
            let savedTransform = $1.transform
            item.transform = getStartTransformPosition()
            
            UIView.animate(withDuration: duration, delay: Double($0) * 0.35 , options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                item.transform = savedTransform
                
                }, completion: completion)
        }
        
    }
    
    func getStartTransformPosition() -> CGAffineTransform {
       
        return CGAffineTransform(translationX: self.view.frame.size.width, y: self.view.frame.size.height)
    }
    
    
    
    
    //MARK: - UIGesture Recognizers
    
    func pinchedView(_ sender:UIPinchGestureRecognizer) {
       
        let picture = sender.view as? ItemDisplay
        
        guard picture != nil else {
            return
        }

        self.desktop.bringSubview(toFront: sender.view!)
        
        let scale = sender.scale
    
        if (picture!.isZoomingAlowed(scale) || scale < 1) {
            picture!.transform = picture!.transform.scaledBy(x: scale, y: scale)
        }

        sender.scale = 1
        
    }
    
    
    func draggedView(_ sender:UIPanGestureRecognizer) {
        
       self.desktop.bringSubview(toFront: sender.view!)
        
        let picture = sender.view as? ItemDisplay
        
        guard picture != nil else {
            return
        }
        
        picture?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        var translation = sender.translation(in: self.desktop)
        
        let originalTransform = picture!.transform
        
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        let margin: CGFloat = 20.0
        
        //get to the edge of the screen
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        // get to the edge of the object
        
        let xBounds = screenWidth - margin
        let yBounds = screenHeight - margin
        
        let deltaX = picture!.transform.tx + picture!.bounds.width / 2.0 + translation.x
        let deltaY = picture!.transform.ty + picture!.bounds.width / 2.0 + translation.y
        
        if (deltaX > xBounds) {
            translation.x = 0
        }
        
        if (deltaY > yBounds) {
            translation.y = 0
        }
        
        if (deltaX < margin){
            translation.x = 0
        }
        
        if (deltaY < margin) {
            translation.y = 0
        }
        
        
        let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        picture!.transform = originalTransform.concatenating(transform)
        
        

        if (imageIsOverDeleteArea(CGPoint(x: deltaX, y: deltaY))) {

            UIView.animate(withDuration: 0.4, animations: {
                picture?.alpha = 0.3

            })
            self.animateTrashLid(true)
        } else {
            UIView.animate(withDuration: 1.5, animations: {
                picture?.alpha = 1
              
            })
            self.animateTrashLid(false)
            
        }
     
        if sender.state == UIGestureRecognizerState.ended {
            if (imageIsOverDeleteArea(CGPoint(x: deltaX, y: deltaY))) {
                UIView.animate(withDuration: 0.6, animations: {
                   
                    sender.view!.transform = originalTransform.scaledBy(x: 0.0, y: 0.0)
                    }, completion: {
                        completed in
                      // UIView.animateWithDuration(2.6, animations: {
                        self.deleteMoodboardImage(picture!)
                        picture?.alpha = 0
                    //    })
                })
                
            }
        }

        
        showTrashCan()
        
    }
    
    
    func rotatedView(_ sender:UIRotationGestureRecognizer) {
        
        let radians = sender.rotation
        switch sender.state {
        case .began:
            sender.view!.transform = sender.view!.transform.rotated(by: radians)
            
            break
            
        case .changed:
            sender.view!.transform = sender.view!.transform.rotated(by: radians)
            sender.rotation = 0
            break
            
        default:
            break
        }
     
    }
    
    
    func tappedView(_ sender: UITapGestureRecognizer) {
        
        let tapLocation = sender.location(in: sender.view!.superview)
        let t = sender.view!.transform
        if sender.view!.layer.presentation()!.frame.contains(tapLocation) {
            self.desktop.bringSubview(toFront: sender.view!)
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.9, options: .allowUserInteraction, animations: {
                sender.view!.transform = t.scaledBy(x: 1.01, y: 1.01)
                
                }, completion: { finished in
                    
                    sender.view!.transform = t.scaledBy(x: 1.0, y: 1.0)
            })
        }
        
    }
    
    
//MARK: - Delete Functionality
    
    func hideTrashCan () {

        //if it is already hidden - no action now, repeat later
        if (viewDeleteArea.alpha == 0)  {
            setTrashCanTimer()
            return
        }
        
        //if it is opened - don't hide it now, repeat later
        if (TrashcanOpen == true) {
            setTrashCanTimer()
            return
        }
        
        viewDeleteArea.animateDisappearance()
    }

    func setTrashCanTimer() {
        trashCanTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MoodboardDesktopVC.hideTrashCan), userInfo: nil, repeats: false)
    }
    
    func showTrashCan () {

        trashCanTimer?.invalidate()
        setTrashCanTimer()
        
        guard viewDeleteArea.alpha == 0 else {
            return
        }
        
        viewDeleteArea.animateAppearance()
        
    }

    
    
    func imageIsOverDeleteArea(_ testPoint: CGPoint) -> Bool {
        
        return viewDeleteArea.frame.contains(testPoint)
      
    }

    
    func deleteMoodboardImage(_ picture: ItemDisplay) {

        picture.alpha = 0
        picture.item?.imageMoodboard.addToMoodBoard(false)
        picture.removeFromSuperview()
        self.animateTrashLid(false)
        self.saveOnscreenMoodBoardItems()
        
    }
    
    
    func animateTrashLid(_ Open: Bool) {

        let nullTransform = CATransform3DIdentity

        if Open {
            if !TrashcanOpen {
                TrashcanOpen = true
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {() -> Void in
                    self.lidTrash.layer.transform = CATransform3DRotate(nullTransform, 0.9, 0.0, 0.0, 1.0)
                    }, completion: {(finished: Bool) -> Void in
                })
            }
        }
        else {
            if TrashcanOpen {
                TrashcanOpen = false
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {() -> Void in
                    self.lidTrash.layer.transform = CATransform3DRotate(nullTransform, 0, 0.0, 0.0, 1.0)
                    }, completion: {(finished: Bool) -> Void in
                })
            }
        }
    }

    
    
    
    
}







