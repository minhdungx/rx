//
//  ChangeAvatarViewController.swift
//  rx
//
//  Created by DungHM on 24/12/24.
//

import UIKit
import RxSwift
import RxCocoa
let avatarImages = [UIImage(systemName: "dog.fill"), UIImage(systemName: "person.fill"),UIImage(systemName: "cat.fill")]

class ChangeAvatarViewController: UIViewController {
    private let bag = DisposeBag()
    private let selectedPhotosSubject = PublishSubject<UIImage>()
    
    var selectedPhotos: Observable<UIImage> {
        return selectedPhotosSubject.asObservable()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    setupCollectionView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedPhotosSubject.onCompleted()
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AvatarCell", bundle: nil), forCellWithReuseIdentifier: "AvatarCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChangeAvatarViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        cell.avatarImage.image = avatarImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhotosSubject.onNext(avatarImages[indexPath.row] ?? UIImage())
    }
}
