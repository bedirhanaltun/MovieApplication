//
//  toDetailsVC.swift
//  MovieApplication
//
//  Created by Bedirhan Altun on 26.07.2022.
//

import UIKit
import Kingfisher
class toDetailsVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Null Variables
    
    var selectedTypeLabel = ""
    var selectedImdbLabel = ""
    var selectedYearLabel = ""
    var selectedTitleLabel = ""
    var selectedPoster = ""
    var selectedResults = ""
    var selectedResponse = ""
    var selectedImage = ""
    
    
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var imdbLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        setSpinner()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){[self] in
            typeLabel.text = "Type : \(selectedTypeLabel)".capitalized
            imdbLabel.text = "Imdb ID : \(selectedImdbLabel)"
            yearLabel.text = "Year : \(selectedYearLabel)"
            titleLabel.text = "Movie Name : \(selectedTitleLabel)"
            resultsLabel.text = "Total Results : \(selectedResults)"
            responseLabel.text = "Response : \(selectedResponse)"
            
            //Converting String to ImageView with KingFisher Library
            imageView.kf.setImage(with: URL(string: selectedImage))
            
        }
        if imageView.image != nil {
            removeSpinner()
        }
        
        
        titleLabel.textColor = .white
        imdbLabel.textColor = .white
        yearLabel.textColor = .white
        typeLabel.textColor = .white
        resultsLabel.textColor = .white
        responseLabel.textColor = .white
        
    }
    
    //Set Spinner and Loading Label
    
    func setSpinner(){
        activityIndicator.startAnimating()
        activityIndicator.style = .medium
        activityIndicator.color = .white
        loading.textColor = .white
        loading.text = "Loading"
    }
    
    //Remove Spinner and Loading Label
    
    func removeSpinner(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.loading.isHidden = true
        }
    }
    
    //Clear Button Settings And Actions
    
    @IBAction func clearButton(_ sender: Any) {
        
        typeLabel.text = ""
        imdbLabel.text = ""
        yearLabel.text = ""
        titleLabel.text = ""
        resultsLabel.text = ""
        responseLabel.text = ""
        
        view.backgroundColor = .darkGray
        
        imageView.image = UIImage(named: "clickme")
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToFirstViewController))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    //Selector Func For ImageView
    
    @objc func goToFirstViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

