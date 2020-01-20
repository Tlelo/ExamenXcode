//
//  HomeTableViewController.swift
//  Homeworks
//
//  Created by Carlos Tlelo on 1/17/20.
//  Copyright © 2020 Carlos Tlelo . All rights reserved.
//

import UIKit
import Firebase


// Archivo o clase que nos sirve para  mostrar l tareas creada
class HomeTableViewController: UITableViewController {
    
    var tasks = [Task]()
    
    
    // Funcion que nos sirve para carga una sola vez, al momento de llamar una vez
    override func viewDidLoad() {
        super.viewDidLoad()

       checkIfUserIsLoggedIn()
        
    }
    
    // Esta funcion se ejecuta constantemente
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTask()
        tableView.reloadData()
    }
    
    
    //Funcion para revisar si el usuario esta logeado, si en dado caso no esta logeado, se hace logout automaticamente
    func checkIfUserIsLoggedIn() {
        
        if Auth.auth().currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        } else {
            
        }
        
    }

    // MARK: - Table view data source
    
    //Funcion para mostrar el numero de secciones en el TableViewController
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // Funcion donde nos mostrara el total de componentes en el tableViewController
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    

    // Funcion para la relacion de los componentes del tableViewCell, con el tableViewController
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        
        let task = tasks[indexPath.row]
        
        cell.taskLabel.text = task.task
        cell.dateLabel.text = task.date

        return cell
    }
    
    
    // Funcion de tableView, para darle anchure a la fila
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    
    // Funcion que nos trae todas las tareas, y las guarda en un array, de acuerdo al usuario
    func fetchTask() {
        
        //vacias el arreglo que vas a utilizar
        tasks.removeAll()
        
        // obtienes el id del usuario que esta logeado
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        // Obtienes las tareas gauardas, por medio  de la referencia hacia la rama "tasks"
        Database.database().reference().child("tasks").observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if uid == dictionary["userId"] as? String {
                    let task = Task()
                    task.idTask = snapshot.key
                    task.date = dictionary["date"] as? String
                    task.task = dictionary["task"] as? String
                    task.time = dictionary["time"] as? NSNumber
                    self.tasks.append(task)
                    
                }
                
                
            }
            
            self.tasks.sort(by: {(task2, task1) -> Bool in
                                          
                return Int(task2.time!.intValue) > Int(task1.time!.intValue)
                
            })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }, withCancel: nil)
    }
    
    
    // Funcion de logout, desde el boton
    @IBAction func logoutAction(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            
             
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
             controller.modalPresentationStyle = .fullScreen
             present(controller, animated: true, completion: nil)
            
            
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
        }
    }
    
    // Funcion para hacer logout automaticamente cuando inicia la app, por si no esta logeado el usuario
    @objc func handleLogout() {
           
           do {
               try Auth.auth().signOut()
          
           } catch let logoutError {
               
            print("Failed logout", logoutError)
           }
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true, completion: nil)
           
       }
    
    
    // Esta funcion es cuando seleccionas la tarea, y te manda a editarla
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        let indexPath = tableView.indexPathForSelectedRow!
        print(indexPath.row)
        
        
        let task = tasks[indexPath.row]
        
        let taskSent = task
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditTaskViewController") as! EditTaskViewController
        controller.task = taskSent
        self.navigationController?.pushViewController(controller, animated: true)
       
        
       
        
    }
    
    
    // Funcion eliminar
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        let task = self.tasks.remove(at: indexPath.row)
        
        guard let idPost = task.idTask else { return }
        
        Database.database().reference().child("tasks").child(idPost).removeValue { (error, ref) in
            if error != nil {
                print(error?.localizedDescription)
            }
            print("tarea eliminada")
        }
        
        self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
       
    }
    

}
