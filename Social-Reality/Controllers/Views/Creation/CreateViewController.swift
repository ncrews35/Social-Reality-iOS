//
//  ViewController.swift
//  Social-Reality
//
//  Created by Nick Crews on 2/26/21.
//

import UIKit
import RealityKit
import ARKit
import PencilKit
import Vision

// MARK: Content Creation View Controller

class CreateViewController: UIViewController {
    
    @IBOutlet weak var arView: ARViewCreation!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var tutorialScrollView: UIScrollView!
    @IBOutlet weak var tutorialPageControl: UIPageControl!
    
    @IBOutlet weak var recordButtonView: RecordButton!
    @IBOutlet weak var leftBottomButton: UIButton!
    @IBOutlet weak var rightBottomButton: UIButton!
    @IBOutlet weak var toolkitView: UIView!
    @IBOutlet weak var toolkitButton1: UIButton!
    
    @IBOutlet weak var searchUserContentView: UIView!
    @IBOutlet weak var searchUserView: SearchUsersView!
    @IBOutlet weak var bottomSearchUserConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomContentView: UIView!
    @IBOutlet weak var bottomContentConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolsSegment: CustomSegmentedControl! {
        didSet {
            toolsSegment.setButtonTitles(buttonTitles: [
                ("", UIImage(systemName: "square.grid.3x3.fill")),
                ("", UIImage(named: Images.pinDrop.rawValue)),
                ("", UIImage(systemName: "heart.fill"))
            ])
            toolsSegment.selectorViewColor = .mainText
            toolsSegment.selectorTextColor = .mainText
            toolsSegment.textColor = .lightGray
            toolsSegment.delegate = self
            toolsSegment.backgroundColor = .clear
        }
    }
    
    private var bottomConstraintDefault: CGFloat = 120
    private var bottomConstraintTop: CGFloat = 0
    
    private var changingShape = false
    private var animating = false
    private var selectedColor: UIColor = .primary
    private var selectedUsers = [UserModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomConstraintTop = -view.frame.height * 0.7
        
        tabBarItem.tag = TabBarItemTag.thirdViewController.rawValue
        
        tutorialScrollView.delegate = self

        setupView()
        
        arView.setupView()
        
    }
    
    func setupView() {
        
        searchUserView.delegate = self
        
        toolkitView.alpha = 0
        recordButtonView.alpha = 0
        leftBottomButton.alpha = 0
        rightBottomButton.alpha = 0
        
        toolkitButton1.tintColor = .white
        
        view.sendSubviewToBack(arView)
        bottomContentConstraint.constant = bottomConstraintDefault
        bottomSearchUserConstraint.constant = bottomConstraintDefault
        backView.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
    }
    
    func changeShape() {
        
        self.changingShape = true
        bottomContentConstraint.constant = bottomConstraintTop
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
    
    func closeChange() {
        self.changingShape = false
        bottomContentConstraint.constant = bottomConstraintDefault
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }

    }
    
    func startVideoMode() {
        bottomContentConstraint.constant = 200
        UIView.animate(withDuration: 0.4) {
            self.recordButtonView.alpha = 1
            self.toolkitView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
    
    func endVideoMode() {
        bottomContentConstraint.constant = bottomConstraintDefault
        UIView.animate(withDuration: 0.4) {
            self.recordButtonView.alpha = 0
            self.toolkitView.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
    
    func presentColorSelector() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = selectedColor
        picker.delegate = self

        self.present(picker, animated: true, completion: nil)
    }
    
    func presentSearchUser() {
        bottomSearchUserConstraint.constant = bottomConstraintTop
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.searchUserView.presented()
        }
    }
    
    func hideSearchUser() {
        bottomSearchUserConstraint.constant = bottomConstraintDefault
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
    
    @IBAction func tapShapeIcon(_ sender: UIButton) {
        sender.jump()
        changingShape ? closeChange() : changeShape()
    }
    
    @IBAction func tapShapeDone(_ sender: UIButton) {
        sender.jump()
        closeChange()
    }
    
    @IBAction func holdRecord(_ gestureRecognizer: UILongPressGestureRecognizer) {
       if gestureRecognizer.state == .began {
        Buzz.medium()
        recordButtonView.animateCircle(duration: 30)
       } else if gestureRecognizer.state == .ended {
        Buzz.medium()
        recordButtonView.stopAnimating()
       }
    }
    
    @IBAction func tapSetColor(_ sender: UIButton) {
        presentColorSelector()
    }
    
    @IBAction func tapTagUser(_ sender: UIButton) {
        presentSearchUser()
    }
    
    
    @IBAction func tapRecord(_ sender: UIButton) {
//        recordButtonView.animateCircle(duration: 10)
    }
    
    @IBAction func tapBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension CreateViewController: SearchUserDelegate {
 
    func selectUsers(models: [UserModel]) {
        selectedUsers = models
    }
    func dismissSearchView() {
        hideSearchUser()
    }

}

extension CreateViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        rightBottomButton.tintColor = viewController.selectedColor
        selectedColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        rightBottomButton.tintColor = viewController.selectedColor
        selectedColor = viewController.selectedColor
    }
    
}

extension CreateViewController: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        
    }
    
}

// MARK: Augmented Reality Functionality

extension CreateViewController {
    
    func initializeReality() {

        self.arView.startCoaching()
        
        let box = CustomBox(color: .red)
        
        arView.installGestures(.all, for: box) // Can change what gestures to use
        box.generateCollisionShapes(recursive: true)
        
        arView.scene.anchors.append(box) 
        
        
        let mesh = MeshResource.generateText(
            "RealityKit",
            extrusionDepth: 0.1,
            font: .systemFont(ofSize: 2),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byTruncatingTail)
        
        let material = SimpleMaterial(color: .white, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.scale = SIMD3<Float>(0.03, 0.03, 0.1)
        
        box.addChild(entity)
        
        entity.setPosition(SIMD3<Float>(0, 0.05, 0), relativeTo: box)
        
    }
    
    
    
}

// MARK: Tutorial Functionality

extension CreateViewController {
    
    @IBAction func tapGetStarted(_ sender: UIButton) {
        sender.pulsate()
        UIView.animate(withDuration: 0.4) {
            self.backView.alpha = 0
            self.tutorialView.alpha = 0
            self.toolkitView.alpha = 1
            self.recordButtonView.alpha = 1
            self.leftBottomButton.alpha = 1
            self.rightBottomButton.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.initializeReality()
        }
        
    }
    
    @IBAction func changePager(_ sender: UIPageControl) {
        switch sender.currentPage {
        case 0:
            scrollToOffset(0)
        case 1:
            scrollToOffset(view.frame.width)
        case 3:
            scrollToOffset(view.frame.width * 2)
        default:
            scrollToOffset(0)
        }
    }
    
}

extension CreateViewController {
    
    @IBAction func bottomContentPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        
        
        if translation.y < 0 {
            if gestureView.frame.minY + translation.y >= view.frame.height * 0.2 {
                bottomContentConstraint.constant = bottomContentConstraint.constant + translation.y
            } else {
                bottomContentConstraint.constant = bottomConstraintTop
            }
        } else if translation.y > 0 {
            if bottomContentConstraint.constant + translation.y <= bottomConstraintDefault {
                bottomContentConstraint.constant = bottomContentConstraint.constant + translation.y
            } else {
                bottomContentConstraint.constant = bottomConstraintDefault
            }
        }
        
        guard gesture.state == .ended else {
            gesture.setTranslation(.zero, in: view)
            return
        }
        
        let velocity = gesture.velocity(in: view)
        
        if velocity.y > 100 {
            bottomContentConstraint.constant = bottomConstraintDefault
        } else if velocity.y < -100 {
            bottomContentConstraint.constant = bottomConstraintTop
        } else if gestureView.frame.minY < view.frame.height * 0.5 {
            bottomContentConstraint.constant = bottomConstraintTop
        } else {
            bottomContentConstraint.constant = bottomConstraintDefault
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
        gesture.setTranslation(.zero, in: view)
        
    }
    
    @IBAction func bottomSearchUserPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        
        
        if translation.y < 0 {
            if gestureView.frame.minY + translation.y >= view.frame.height * 0.2 {
                bottomSearchUserConstraint.constant = bottomSearchUserConstraint.constant + translation.y
            } else {
                bottomSearchUserConstraint.constant = bottomConstraintTop
            }
        } else if translation.y > 0 {
            if bottomSearchUserConstraint.constant + translation.y <= bottomConstraintDefault {
                bottomSearchUserConstraint.constant = bottomSearchUserConstraint.constant + translation.y
            } else {
                bottomSearchUserConstraint.constant = bottomConstraintDefault
            }
        }
        
        guard gesture.state == .ended else {
            gesture.setTranslation(.zero, in: view)
            return
        }
        
        let velocity = gesture.velocity(in: view)
        
        if velocity.y > 100 {
            bottomSearchUserConstraint.constant = bottomConstraintDefault
        } else if velocity.y < -100 {
            bottomSearchUserConstraint.constant = bottomConstraintTop
        } else if gestureView.frame.minY < view.frame.height * 0.5 {
            bottomSearchUserConstraint.constant = bottomConstraintTop
        } else {
            bottomSearchUserConstraint.constant = bottomConstraintDefault
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
        gesture.setTranslation(.zero, in: view)
        
    }
    
}

extension CreateViewController: UIScrollViewDelegate {
    
    func scrollToOffset(_ offset: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4) {
                self.tutorialScrollView.contentOffset.x = offset
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            tutorialPageControl.currentPage = 0
        } else if scrollView.contentOffset.x == view.frame.width {
            tutorialPageControl.currentPage = 1
        } else if scrollView.contentOffset.x == view.frame.width * 2 {
            tutorialPageControl.currentPage = 2
        }
    }
    
}
