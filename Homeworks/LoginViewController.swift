//
//  LoginViewController.swift
//  Homeworks
//
//  Created by Carlos Tlelo on 1/17/20.
//  Copyright © 2020 Carlos Tlelo. All rights reserved.
//

import UIKit
import Firebase


//Clase o archivo que permitira hacer Login
class LoginViewController: UIViewController {
    
    
    //Referencia de los componente a utilizar en la interfaz
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // Funcion que nos permitira hacer el login
    @IBAction func loginAction(_ sender: Any) {
        
        
        // Desempaque los textField
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        
        //Valida si  no estan vacios los campos
        if email == "" || password == "" {
            
            let alertController = UIAlertController(title: "Error de Login", message: "Deben de estar lleno todos los campos", preferredStyle: .alert)
   
            
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            // Si no esta vacion ejecuta el else
        } else {
            
            // Referencia para hacer login, con login y password
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                
                if let err = err {
                    
                    let alertController = UIAlertController(title: "Error de Login", message: "\(err.localizedDescription)", preferredStyle: .alert)
                    
                             
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                             
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                print("Successfully logged back in the with user:", result?.user.uid)
                
                
                // Sentencias que te mandaran al TableViewController, donde tienes todas las tareas guardas, por medio del identificar
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
                let navController = UINavigationController(rootViewController: controller)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
                
            }
        }
        
        
    }
    
    
    @IBAction func showRegisterAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
}
