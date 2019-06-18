//
//  ViewController.swift
//  InfiniteScroll
//
//  Created by Kraig Wastlund on 9/7/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    
    let imageView1 = UIImageView()
    let imageView2 = UIImageView()
    let imageView3 = UIImageView()
    
    var images = [UIImage(named: "1.jpg"), UIImage(named: "2.jpg"), UIImage(named: "3.jpg")]
    
    var scrollXVelocity: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myScrollView.delegate = self
        myScrollView.addSubview(imageView1)
        myScrollView.addSubview(imageView2)
        myScrollView.addSubview(imageView3)
        
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
        print(repeatedString(s: "aba", n: 10))
    }
    func repeatedString(s: String, n: Int) -> Int {
        let lengthOfS = s.count
        let baseMultiplier = n / s.count
        let leftOverChars = n % s.count
        let asInBase = String(repeating: s.filter { $0 == "a" }, count: baseMultiplier)
        let asLeftOver = s[..<String.Index(encodedOffset: leftOverChars)].filter { $0 == "a" }
        return asInBase.count + asLeftOver.count
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageView1.image = images[0]
        imageView2.image = images[1]
        imageView3.image = images[2]
        myScrollView.setContentOffset(CGPoint(x: 770 * 1.25, y: 0), animated: true)
    }
    
    private func setConstraints() {
        myScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[iv1][iv2][iv3]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iv1": imageView1, "iv2": imageView2, "iv3": imageView3]))
        myScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[iv1]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iv1": imageView1, "iv2": imageView2, "iv3": imageView3]))
        myScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[iv2]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iv1": imageView1, "iv2": imageView2, "iv3": imageView3]))
        myScrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[iv3]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iv1": imageView1, "iv2": imageView2, "iv3": imageView3]))
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollXVelocity = velocity.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // width of trogdoor image = 770
        let currentX = myScrollView.contentOffset.x
    
        if currentX > (770 * 2) { // shift to the left and keep animating
            UIView.animate(withDuration: 0.0) { [weak self] in
                if let s = self {
                    s.myScrollView.contentOffset = CGPoint(x: currentX - 770, y: 0)
                    let element = s.images.remove(at: 0)
                    s.images.insert(element, at: 2)
                    s.imageView1.image = s.images[0]
                    s.imageView2.image = s.images[1]
                    s.imageView3.image = s.images[2]
                }
            }
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveLinear, .allowUserInteraction], animations: { [weak self] in
                if let s = self {
                    s.myScrollView.contentOffset = CGPoint(x: s.myScrollView.contentOffset.x + s.scrollXVelocity, y: 0)
                }
            }, completion: nil)
        } else if currentX < 770 { // shift to the right and keep animating
            UIView.animate(withDuration: 0.0) { [weak self] in
                if let s = self {
                    s.myScrollView.contentOffset = CGPoint(x: currentX + 770, y: 0)
                    let element = s.images.remove(at: 2)
                    s.images.insert(element, at: 0)
                    s.imageView1.image = s.images[0]
                    s.imageView2.image = s.images[1]
                    s.imageView3.image = s.images[2]
                }
            }
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveLinear, .allowUserInteraction], animations: { [weak self] in
                if let s = self {
                    s.myScrollView.contentOffset = CGPoint(x: s.myScrollView.contentOffset.x + s.scrollXVelocity, y: 0)
                }
            }, completion: nil)
        }
    }
}
