//
//  ViewController.swift
//  PhotoLibraryApp
//
//  Created by Rolan Marat on 2/1/23.
//

import UIKit

enum PhotoAppImageSource {
    case photoLibrary
    case camera
}

class ViewController: UIViewController, UINavigationControllerDelegate  {

    @IBOutlet weak var selectedImageView: UIImageView!
    private var imagePicker: UIImagePickerController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Take image
    @IBAction func takePhoto(_ sender: UIButton) {
        let imageOptionsController = UIAlertController(title: "Select Source",
                                             message: "What would you like to use to take photos?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertOption1 = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.selectImageFrom(.camera)
            }
            imageOptionsController.addAction(alertOption1)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let alertOption2 = UIAlertAction(title: "Photo Library",
                                             style: .default)  { [weak self] _ in
                self?.selectImageFrom(.photoLibrary)
            }
            imageOptionsController.addAction(alertOption2)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        imageOptionsController.addAction(cancelAction)
        
        present(imageOptionsController, animated: true)
    }

    func selectImageFrom(_ source: PhotoAppImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker?.delegate = self
        switch source {
        case .camera:
            imagePicker?.sourceType = .camera
        case .photoLibrary:
            imagePicker?.sourceType = .photoLibrary
        }
        if let imagePicker = imagePicker {
            present(imagePicker,
                    animated: true,
                    completion: nil)
        }
    }

    @IBAction func saveImage(_ sender: AnyObject) {
        guard let selectedImage = selectedImageView.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage,
                                       self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    //MARK: - Add image to Library
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: Error?,
                     contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(with: "Could not save the image",
                      message: error.localizedDescription)
        } else {
            showAlert(with: "Image Saved",
                      message: "Image successfully saved to the photo library.")
        }
    }

    func showAlert(with title: String,
                   message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
 }

 extension ViewController: UIImagePickerControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker?.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Could not find the image!")
            return
        }
        selectedImageView.image = selectedImage
    }
}
