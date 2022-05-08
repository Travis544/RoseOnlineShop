//
//  ListingViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/8/22.
//

import UIKit

class ListingViewController: UIViewController {
    var category : String!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var listingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = contentView.frame.size
        // Do any additional setup after loading the view.
        constructStackView()
    }
    
    let scrollViewContainer: UIStackView
    = {
            let view = UIStackView()

            view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 20
            view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        
        
        return view
        }()
    
    
//    just testing--will fix later.
    func constructStackView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(scrollViewContainer)
        
        
        let topConstraint = NSLayoutConstraint(item: scrollViewContainer, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: scrollViewContainer, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0.0)
        let leadingConstraint = NSLayoutConstraint(item: scrollViewContainer, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant:0)
        let trailingConstraint = NSLayoutConstraint(item: scrollViewContainer, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1, constant: 0)
        
        let widthC = scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0.0)
        let heightC =             scrollViewContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1/3*10)
        
        NSLayoutConstraint.activate([
            topConstraint, bottomConstraint, leadingConstraint, trailingConstraint, widthC, heightC
        ]
                                    
                                    
        )
//        self.scrollView.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        
        for i in 1...10{
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            scrollViewContainer.addArrangedSubview(stackView)

//            scrollView.addSubview(stackView)
            stackView.axis = .horizontal
            stackView.contentMode = .scaleToFill
            stackView.distribution = .fillEqually

            stackView.alignment = .fill


            stackView.spacing = 5
            let button = UIButton()
            button.setTitle("Test", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = UIColor.blue
            stackView.addArrangedSubview(button)

            var v=UIView()
            stackView.addArrangedSubview(v)
            v.backgroundColor=UIColor.blue

            v=UIView()
            stackView.addArrangedSubview(v)
            v.backgroundColor=UIColor.blue
        }
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
