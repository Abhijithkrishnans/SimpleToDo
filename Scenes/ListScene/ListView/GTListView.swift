//
//  GTListView.swift
//  SimpleTodo
//
//  Created by Abhijithkrishnan on 30/03/22.
//

import UIKit

// MARK: View Protocol
/// Responsibile for view requirements
///List fetch/update and error are injected through this interface
protocol ToDoViewProtocol:AnyObject {
    ///Interactor connection requirement
    var GTListInteractor:GTInteractorProtocol? {get set}
    
    /// Router connection requirement
    var GTListRouter:GTRouterProtocol? {get set}
    
    var toDoList:[GTListDataModelProtocol] {get set}
    /// ToDo Fetching interfaces
    func didFetchToDoList(_ todoList:[GTListDataModelProtocol])
    func bindError(_ error:Error)
}

class GTListView: UIViewController,ToDoViewProtocol,UITextFieldDelegate{
    //MARK: VIP Connectors
    var GTListRouter: GTRouterProtocol?
    var GTListInteractor: GTInteractorProtocol?
    
    // MARK: Outlets connections
    @IBOutlet weak var tblRecipeListView: UITableView!
    
    //MARK: ToDo custom properties
    /// Observing all the changes to update the UI
    var toDoList = [GTListDataModelProtocol]() {
        didSet {
            reloadUI()
        }
    }
    lazy var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    lazy var deleteButton:UIBarButtonItem =  {
      let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash,
                              target: self,
                              action: #selector(clickedDeleteAllBtn))
        return barButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewElements()
    }
}
// MARK: UI Initialization Helper Methods
extension GTListView {
    private func initializeViewElements (){
        /// Configuring navigation style
        navigationController?.navigationBar.prefersLargeTitles = true
        title = GTConstants.screenTitle.todo
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(clickedAddBtn))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = deleteButton
        view.addSubview(activityIndicator)
        activityIndicator.style = .large
        activityIndicator.color = .blue
        activityIndicator.center = view.center
        /// Initial method calls
        fetchToDoList()
    }
}

//MARK: Generic Operations
extension GTListView {
    private func fetchToDoList() {
            self.activityIndicator(isStart: true)
            self.GTListInteractor?.fetchToDoList()
    }
    /// Todo List Reload Logic
    private func reloadUI() {
        DispatchQueue.main.async {
            ///Refresh the list subsequent to Add, Update and delete operations
            self.tblRecipeListView.reloadData()
            ///Enable the delete button only after checking whether there any item to delete
            self.deleteButton.isEnabled = self.toDoList.isEmpty ? false : true
        }
    }
    /// Activitiindicator logic
    private func activityIndicator(isStart:Bool){
        DispatchQueue.main.async {
            isStart ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
        
    }
}

//MARK: Action handlers
extension GTListView {
    @objc func clickedAddBtn(){
        showAlertWith(isUpdate: false)
    }
    @objc func clickedDeleteAllBtn(){
        deleteAll()
    }
}

//MARK: DB Handling Helper Methods
extension GTListView {
   private func showAlertWith(_ toDoItem:GTListDataModelProtocol? = nil,isUpdate:Bool){
       var toDoName = toDoItem?.name ?? GTConstants.fieldNames.empty
        var ToDodescription = toDoItem?.description ?? GTConstants.fieldNames.empty
        let alert = UIAlertController(
            title: isUpdate ? GTConstants.screenTitle.updatetodo:GTConstants.screenTitle.addtodo,
            message: GTConstants.alertMessage.addToDoMessage,
            cancelButtonTitle: GTConstants.fieldNames.Cancel,
            saveButtonTitle: isUpdate ? GTConstants.fieldNames.Update:GTConstants.fieldNames.Save,
            validate: .nonEmpty,
            textFieldConfiguration: [
                { $0.placeholder = GTConstants.placeholder.addtodoname
              $0.text = toDoName
            },{ $0.placeholder = GTConstants.placeholder.addtododescription
                $0.text = ToDodescription
            }],
            onCompletion: {[weak self] result in
                switch result {
                case .cancel:
                    break
                case .save(let textFields):
                  toDoName = textFields?.filter{$0.tag == 0}.first?.text ?? GTConstants.fieldNames.empty
                  ToDodescription = textFields?.filter{$0.tag == 1}.first?.text ?? GTConstants.fieldNames.empty
                    self?.initiateDBOperationWith(toDoItem, toDoName, ToDodescription, isUpdate: isUpdate)
                    break
                }})
        
        ///Connecting with Router to present the alert controller
        GTListRouter?.navigationController = self.navigationController
        GTListRouter?.navigateTo(alert, isModelPresentation: true)
    }
}
//MARK: ToDo Add Update
extension GTListView {
    private func initiateDBOperationWith(_ todoItem:GTListDataModelProtocol?, _ title:String, _ description:String, isUpdate:Bool){
        activityIndicator(isStart: true)
        if let id = todoItem?.id {
            GTListInteractor?.insertToDoItem(title, description, id, isUpdate)
        }else{
            GTListInteractor?.insertToDoItem(title, description, UUID(), isUpdate)
        }
    }
}

//MARK: Protocol requirement implementation
extension GTListView {
    //** Initial fetch and updated results injecte through this interface
    func didFetchToDoList(_ todoList:[GTListDataModelProtocol]) {
        toDoList = todoList
        activityIndicator(isStart: false)
    }
    //** All the exceptions are exposed through this interface
    func bindError(_ error:Error) {
        activityIndicator(isStart: false)
        UIAlertController.showAlert(title: error.localizedDescription, message: GTConstants.fieldNames.empty, cancelButtonTitle: GTConstants.fieldNames.Ok, otherButtons: [], preferredStyle: .alert, vwController: self) { action, index in
        }
    }
}

// MARK: TableView delegates and datasource methods
extension GTListView:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
     }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GTListCell", for: indexPath) as! GTListCell
        cell.configureCellWith(toDoList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteSigneItem(indexPath, item: toDoList[indexPath.row])
            break
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlertWith(toDoList[indexPath.row], isUpdate:true)
    }
}

//MARK: Deletion Helper Methods
extension GTListView {
    private func deleteAll(){
        UIAlertController.showAlert(title: GTConstants.fieldNames.empty, message: GTConstants.alertMessage.deleteAll, cancelButtonTitle: GTConstants.fieldNames.Yes, otherButtons: [GTConstants.fieldNames.No], preferredStyle: .alert, vwController: self) {[weak self] action, index in
            switch index {
            case 0:
                self?.GTListInteractor?.deleteAllItems()
                break
            default:
                break
            }
        }
    }
    private func deleteSigneItem(_ indexPath:IndexPath, item:GTListDataModelProtocol){
        UIAlertController.showAlert(title: GTConstants.fieldNames.empty, message: GTConstants.alertMessage.deletesingle, cancelButtonTitle: GTConstants.fieldNames.Yes, otherButtons: [GTConstants.fieldNames.No], preferredStyle: .alert, vwController: self) {[weak self] action, index in
            switch index {
            case 0:
                self?.GTListInteractor?.deleteToDoItem(item)
                self?.toDoList.remove(at: indexPath.row)
                self?.tblRecipeListView.deleteRows(at: [indexPath], with: .automatic)
                break
            default:
                break
            }
        }
    }
}
