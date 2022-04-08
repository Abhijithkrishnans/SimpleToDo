# SimpleToDo
Simple ToDo app with local persistence


## Implementation & Technical details

* Swift Clean Architecture (VIP) has been used for implementation 
* Storyboard are used for UI design since minimal or uncomplicated UI has been followed
* No 3rd party SDK's has been integrated
* CoreData is used for data persistence 

### Usage
* During the initial launch, with empty list and 2 buttons will be displayed at the navigationr bar
* There is a delete all button has been implemented in top left corner to delete all the ToDo List
* Delete all button will be enabled only if the list contains at-least 1 ToDo item
* There is an add ToDo button implementaed in top right corner to add new ToDo
* Upon clicking on add, there will be an alert with 2 textfields will be propmpted to get input details.
* User will have the liberty to Save or Cancel the alert
* Data validation has been applied to the alert's save button since both the fields are set to mandatory
* Upon Saving the data, input details will be persisted in disk using coredata and the data will be listed in the home ToDo List page
* App has the capability to do Add, Update, Delete and Delete all data
* In order to delete a single item, swipe left feature has been implemented.
* In order to updare an item, user has to click on any of the listed item and alert with prefilled deta will be displayed and user can edit the data.

       
 
