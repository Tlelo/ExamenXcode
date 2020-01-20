//
//  EditTaskViewController.swift
//  Homeworks
//
//  Created by Carlos Tlelo  on 1/18/20.
//  Copyright © 2020 Carlos Tlelo . All rights reserved.
//

import UIKit
import Firebase


// Clase o archivo que nos servira para editar la tarea
class EditTaskViewController: UIViewController {
    
    
    // variable tipo objeto task, para que la puedan enviar desde el TableViewController, y asi poder utilizarla aqui
    var task: Task? {
        
        didSet {
            
            
        }
    }
    
    // objetos que se utilizaran en la interfza
    @IBOutlet weak var taksTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // funciion para poder llenar los texfield de la interfaz
        setupTextField()
         //funcion para con un click en la pantalla desaparesca el teclado
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupTextField() {
        
        
        // aqui tambien desempaquetamos las variables que recibimos
        if let task = task?.task {
            
            taksTextField.text = task
        }
        
        // aqui tambien desempaquetamos las variables que recibimos
        if let date = task?.date {
                       
            dateTextField.text = date
        }
    }
    

    // funcion para poder actualizar la info
    @IBAction func updateAction(_ sender: Any) {
        
        
        //desempaquetamos las textfield
        guard let idTask = task!.idTask else { return }
        guard let task = taksTextField.text else { return }
        guard let date = dateTextField.text else { return }
        
        if task == "" || date == "" {
            
            let alertController = UIAlertController(title: "Error de Actualizacion", message: "Debe de llenar todos los campos", preferredStyle: .alert)
            
                     
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                     
            present(alertController, animated: true, completion: nil)
        
        } else {
            
            let dictionaryValues = ["task": task, "date": date] as [String : Any]
            
            
            Database.database().reference().child("tasks").child(idTask).updateChildValues(dictionaryValues, withCompletionBlock: { (error, ref) in
                          
                    if error != nil {
                       print("Failed updated:", error)
                        return
                    }
                          
                    self.navigationController?.popViewController(animated: true)
                          
            })
        }
        
        
    }
    
    // FUncion que nos sirve para  desaparecer el teclado
    @objc func dismissKeyboard() {
              
        view.endEditing(true)
    }
       

}
