//
//  CategoryPageViewController.swift
//  RoseOnlineShop
//
//  Created by Yuanhang on 5/7/22.
//
//           view.addSubview(stackView)
//            stackView.alignment = .fill
//            stackView.distribution = .fillEqually
//            stackView.axis = .vertical
//           stackView.spacing = 20
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//           stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive=true
//           stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive=true
//
//           stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=trues


//        let topConstraint = NSLayoutConstraint(item: myView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 80.0)
//       let bottomConstraint = NSLayoutConstraint(item: myView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 80.0)
//       let leadingConstraint = NSLayoutConstraint(item: myView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 50.0)
//       let trailingConstraint = NSLayoutConstraint(item: myView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 50.0)
//
//       self.view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])


import UIKit

class CategoryPageViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    
    var categories:[String:UIColor]=["Electronics":UIColor.yellow, "Clothing":UIColor.purple, "Books":UIColor.blue]
    override func updateViewConstraints(){
       super.updateViewConstraints()
//       let myView=UIView()
//       myView.backgroundColor=UIColor.yellow
//       let label = UILabel()
//       label.text="THIS IS A TEST"
//       myView.addSubview(label)
//       myView.translatesAutoresizingMaskIntoConstraints = false
        createCategories()

    }
    
    func createCategories(){
        var counter = 0
        for val in categories.keys{
            let button = UIButton()
            button.setTitle(val, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = categories[val]
            button.addTarget(self, action: #selector(categoryPressed), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            button.tag=counter
            counter+=1
        }
    }
    
    @objc func categoryPressed(_ sender: UIButton){
        print("pressed \(Array(categories.keys)[sender.tag])")
        self.performSegue(withIdentifier: kListingSegue, sender: sender)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
