//
//  GalleryViewController.swift
//  OdetteNew
//
//  Created by Marina Huber on 02/06/16.
//  Copyright © 2016 xs2. All rights reserved.


import UIKit
import AlamofireImage


//MARK: - UICollectionView Cell

class ImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.imageView.image = nil
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    var image: Image! {
        
        didSet {
            if let urlString = image?.getURL(.original), let url = APIRouter.staticImage(urlString).URLRequest.url {
                
                self.imageView.af_setImage(
                    withURL: url, placeholderImage: UIImage(), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.4), runImageTransitionIfCached: false, completion: nil)
                
            }
//            self.imageView.loadImageFromOdetteImage(image, size: ImageSize.Original)
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = self.isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}


class GalleryViewController: UIViewController {
    
    var detailsController: WaterfallViewController?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var largeCollectionView: UICollectionView?
    @IBOutlet weak var smallCollectionView: UICollectionView?
    @IBOutlet weak var viewHeader: UIView!
    
    //to animate top and bottom bars
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    
    //to do intial scroll and prevent flickering 
    var initialScrollDone: Bool = false

    @IBOutlet weak var likeBtn: UIButton!
    var imagesBig = Array<Image>()
    var currentImage: Int?
    
    var headerFooterViewsVisible: Bool = true {
        didSet {
            if headerFooterViewsVisible {
                headerTopConstraint.constant = 0
                footerBottomConstraint.constant = 0
                
            }else {
                headerTopConstraint.constant = -80
                footerBottomConstraint.constant = -80
            }
            
            UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
                self.prefersStatusBarHidden

                
                }, completion: nil)
        }
        
    }


    
//MARK: - Actions
    @IBAction func like (_ sender: UIButton) {

        guard currentImage != nil else {
            print ("I cannot mark image as favorite, as I don't know which image is displayed")
            return
        }
        
        var img = imagesBig[currentImage!]
        let isSelected = img.favorite
        
        img.favorite = !isSelected
        sender.isSelected = img.favorite

        if let vc = self.presentingViewController as? DetailViewController {
             vc.reloadSections()
        }
        
    }



    
    @IBAction func back(_ sender: AnyObject) {
        detailsController?.reloadUI()
        dismiss(animated: true, completion: nil)
        
    }
    
  
     override var prefersStatusBarHidden : Bool {
        return !headerFooterViewsVisible
    }
    

//MARK: - UIViewController LifeCycle

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(GalleryViewController.updateHeaderFooterView))
        largeCollectionView?.addGestureRecognizer(gesture)
        view.bringSubview(toFront: viewFooter)
        view.bringSubview(toFront: viewHeader)


        largeCollectionView?.animateAppearanceWithDelay(0.3)
        smallCollectionView?.animateAppearanceWithDelay(0.4)
        
    }


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (!initialScrollDone) {
        let indexPath = IndexPath(item: currentImage ?? 0, section: 0)
        largeCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        smallCollectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            initialScrollDone = true
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.largeCollectionView?.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: true)
     }
    
    
    func updateHeaderFooterView() {
        
        headerFooterViewsVisible = !headerFooterViewsVisible
    }
    
    
}

//MARK: - UICollectionView DataSource

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesBig.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch collectionView {
        case smallCollectionView!:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IDsmall", for: indexPath) as! ImageCollectionViewCell
            cell.image = imagesBig[indexPath.row]
            cell.layer.borderWidth = 1

            return cell
            
            
        case largeCollectionView!:
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IDlarge", for: indexPath) as! ImageCollectionViewCell
            
            cell.image = imagesBig[indexPath.row]
            cell.scrollView?.maximumZoomScale = 5.0
            cell.scrollView?.minimumZoomScale = 1.0
            cell.scrollView?.zoomScale = 1.0
            cell.layer.borderWidth = 0
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionView Delegate

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return collectionView != largeCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if smallCollectionView == collectionView {
            currentImage = indexPath.row
            smallCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            largeCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (collectionView == largeCollectionView) {
            let image = imagesBig[indexPath.row]
            likeBtn.isSelected = image.favorite
        }
        
    }

}

//MARK: - UICollectionView Layout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if smallCollectionView == collectionView  {
        
            return CGSize(width: 50, height: 50)
        
        }
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        if (smallCollectionView == scrollView) {
            let itemsCount: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))
            let collectionViewWidth: CGFloat = collectionView.bounds.width
            
            let itemWidth: CGFloat = 50.0
            let itemsMargin: CGFloat = 10.0
            
            let edgeInsets = (collectionViewWidth - (itemsCount * itemWidth) - ((itemsCount-1) * itemsMargin)) / 2
            
            return UIEdgeInsetsMake(0, edgeInsets, 0, 0)
            
        }
        else {
            
            return UIEdgeInsets.zero
        }
        
    }
}


//MARK: - UIScroolView Delegate

extension GalleryViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if largeCollectionView == scrollView {
            // Unsafe Mutable Pointer in Swift
            let index = Int(targetContentOffset.pointee.x/view.frame.width)
            currentImage = index
            let indexPath = IndexPath(item: index, section: 0)
            smallCollectionView?.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
}

