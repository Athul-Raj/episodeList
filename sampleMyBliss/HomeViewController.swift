//
//  HomeViewController.swift
//  sampleMyBliss
//
//  Created by Athul on 14/12/18.
//  Copyright © 2018 myBliss. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {
    
    var episodesModel = [Episode]()
    var pageNumber = 1
    
    //MARK:-
    override func viewDidLoad() {
        
       getEpisodeForPage(number: pageNumber)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
    //MARK: Collection View Delegate and Data source
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodesModel.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeListTableViewCell
        

        cell.titleLabel.text = episodesModel[indexPath.row].title
        cell.subTitleLabel.text = episodesModel[indexPath.row].subTitle
        cell.dateLabel.text = episodesModel[indexPath.row].date
        

        if let imageURL = episodesModel[indexPath.row].smallImageUrl {
            cell.thumbnailImageView.cacheImage(url: imageURL)
        }
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.white.cgColor

        return cell
    }
    

    //MARK: Scroll View Delegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            pageNumber += 1
            getEpisodeForPage(number: pageNumber)
        }
    }
    
    //MARK: Local Methods
    
    @objc func rotated() {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            self.collectionViewLayout.invalidateLayout()
        default:
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    func getEpisodeForPage (number: Int) {
        WebService.getEpisodesWithPageNumber(number, onSuccess: { (resp) in
            
            for dic in resp {
                self.episodesModel.append(Episode(dic as! [String : Any]))
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }, onFailure: { (errorMessage) in
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            return CGSize(width: (width - 60), height: (width - 60) * 0.56)

        } else {
            return CGSize(width: (width - 60)/2, height: (width - 60)/2 * 0.56)

        }
    }
}
