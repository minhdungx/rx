//
//  ViewController.swift
//  rx
//
//  Created by DungHM on 24/12/24.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    private let bag = DisposeBag()
    private let image = BehaviorRelay<UIImage?>(value: nil)
    
    var avatartIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        image.subscribe(onNext: { [weak self] img in
            self?.avatarImageView.image = img } )
        .disposed(by: bag)
        configUI()
    }
    
 
    func configUI() {
        avatarImageView.layer.cornerRadius = 50.0
        avatarImageView.layer.borderWidth = 5.0
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.masksToBounds = true
        
        let leftBarButton = UIBarButtonItem(title: "Change Avatar", style: .plain, target: self, action: #selector(self.changeAvatar))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    // MARK: Actions
    @IBAction func register(_ sender: Any) {
        RegisterModel.shared().register2(username: usernameTextField.text, password: passwordTextField.text, email: emailTextField.text, avatar: image.value)
            .subscribe(onSuccess: {done in
                print("register success")
            }, onFailure: {error in
                if let error = error as? APIError {
                    print(error.localizedDescription)
                }
                
            })
            .disposed(by: bag)
    }
    
    @IBAction func clear(_ sender: Any) {
    }
    
    @objc func changeAvatar() {
        let vc = ChangeAvatarViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.selectedPhotos.subscribe(onNext: { [weak self] img in
            self?.image.accept(img)
        }, onDisposed: {
            print("complete change")
        }).disposed(by: bag)
    }
    
}
