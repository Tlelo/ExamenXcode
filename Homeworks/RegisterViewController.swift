//
//  RegisterViewController.swift
//  Homeworks
//
//  Created by JCarlos Tlelo  on 1/17/20.
//  Copyright © 2020 Carlos Tlelo . All rights reserved.
//

import UIKit
import Firebase

//Este archivo o clase, es para registrar al usuadio
class RegisterViewController: UIViewController {
    
    // recuerda debes de referencias los componentes de la interfaz con el archivo
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var psswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    //funcion que carga solo una vez, al momento de correr la app
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //funcion de regustron, se crea una accion
    @IBAction func regiterAction(_ sender: Any) {
        
        // recuerda debes de desempaquetar los textfield, para poder utilizar lo que escribe el usuario. Si podras utilizarlo pero los datos vendran
        // de esta forma Optional(dato)
        guard let email = emailTextField.text else { return }
        guard let username = userTextField.text else { return }
        guard let password = psswordTextField.text else { return }
        
        
        // Validacion si no se introdujo nada en cualquier textfield
        if email == "" || username == "" || password == "" {
            
            let alertController = UIAlertController(title: "Error de Registro", message: "Deben de estar lleno todos los campos", preferredStyle: .alert)
            
                     
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                     
            present(alertController, animated: true, completion: nil)
        
            // Aqiui se hace el registro
        } else {
        
            // Utilizas la referencia del Firebase para poder crear el usuario, recuerdad importar la libreria Firebase
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
                if let err = error {
                    
                    let alertController = UIAlertController(title: "Error de Registro", message: "\(err.localizedDescription)", preferredStyle: .alert)
                    
                             
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                             
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let dictionaryValues = ["username": username, "email": email]
                
                let values = [uid: dictionaryValues]
                //hasta aqui ya hiciste autenticacion, ahora ocupas guardar la info en el base de datos
                //Con esta referencia guardas la info en la base de datos, en una ramificacion llamada "users", tu puedes cambiarle el nombre si deses
                Database.database().reference().child("users").updateChildValues(values) { (err, ref) in
                    
                    if let err = err {
                        let alertController = UIAlertController(title: "Error de Registro", message: "\(err.localizedDescription)", preferredStyle: .alert)
                        
                                 
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                 
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    
                    // esta pieza de codigo, te mandara al tableViewController, si en dado caso acepto tu login. Recuerda que se hace por medio del
                    //identificador del TableViewController.
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
                    let navController = UINavigationController(rootViewController: controller)
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true, completion: nil)
                    
                }
            
       
         
            }
        }
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
