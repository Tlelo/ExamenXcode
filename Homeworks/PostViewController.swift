//
//  PostViewController.swift
//  Homeworks
//
//  Created by JCarlos Tlelo  on 1/17/20.
//  Copyright © 2020 Carlos Tlelo . All rights reserved.
//

import UIKit
import Firebase

//Clase o archivo que nos servira para crear una nueva tarea
class PostViewController: UIViewController {
    
    // variable que nos servira para darle formato a la fecha
    var dateFormatter = DateFormatter()
    
    // referencia de los objetos con la interfaz
    @IBOutlet weak var homeworkTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // le damos formato a la fecha
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm"
        
        //funcion para con un click en la pantalla desaparesca el teclado
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    // funcion para guardar la tarea
    @IBAction func saveAction(_ sender: Any) {
        
        
        //obtenemos la fecha del datePicker
        let date = datePicker.date
        //le damos el formato a la fecha y lo convertimos en String
        let dateStr = dateFormatter.string(from: date)
        
        
        //
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let task = homeworkTextField.text else { return }
        
        if task == "" {
            
            let alertController = UIAlertController(title: "Error de Guardado", message: "Debe de asignar la tarea", preferredStyle: .alert)
            
                     
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                     
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            let childRef = Database.database().reference().childByAutoId()
            let time = (Int(NSDate().timeIntervalSince1970))
            
            guard let idPost = childRef.key else { return }
                
            let dictionaryValues = ["userId": uid, "task": task, "time": time, "date": dateStr] as [String : Any]
            
            let values = [idPost: dictionaryValues]
            
             
            Database.database().reference().child("tasks").updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save info to db:", err)
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
           
        
            
        }
        
    }
    
    
    // FUncion que nos sirve para  desaparecer el teclado
    @objc func dismissKeyboard() {
           
        view.endEditing(true)
    }
    
}
