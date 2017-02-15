//SCRAP TESTING
//SCRAP TESTING
//SCRAP TESTING
//SCRAP TESTING
//SCRAP TESTING

import UIKit
import SnapKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        view.setNeedsLayout()
        picker.delegate = self
        navigationItem.rightBarButtonItem = upArrow
    }
    
    //MARK: - Actions - Photo upload
    func presentPic() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.centerImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Setup
    func setupViewHierarchy() {
        view.addSubview(centerImageView)

    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        //ContainerView
        containerView.snp.makeConstraints({ (view) in
            view.width.equalToSuperview()
            view.height.equalTo(75)
            view.top.equalToSuperview()
        })
  
        
        //Center ImageView
        centerImageView.snp.makeConstraints({ (view) in
            view.width.equalToSuperview()
            view.height.equalTo(self.view.snp.width)
            view.top.equalTo(containerView.snp.bottom)
        })
        
    }

    //MARK: - Views
    
    internal lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    internal lazy var centerImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "Selfie10")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    internal lazy var upArrow: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem()
        barButtonItem.title = "upload"
        barButtonItem.style = .plain
        barButtonItem.target = self
        barButtonItem.action = #selector(presentPic)
        return barButtonItem
    }()
 


}

