# Reactive Hybrid Architecture
> Reactive Architecture with NO REACTIVE FRAMEWORK 

#### RHA = (Clean Code Philosophy + MVVM) - 3rd Party Reactive Frameworks



## Description
  Reactive Hybrid Architecture is a term that I have coined after playing with different architectural patterns and philosophies. This architecture is inspired by Robert Cecil Martin (lovingly known as Uncle Bob), Raymond Law and Eric Cerney. I have always considered breaking the complex into its simpler form until its easily understandable by me and thats just what I did in this case to explain you about my architecture.
    
## Why Clean code and MVVM?
  Learning about Clean code and MVVM helped me chalk down the following improvements that I can make to the code.
  
  - Software can be divided into 3 parts:
     - UI
     - Business Logic
     - Data
    Business Logic are the business rules that are less likely to change with the changing external factors such as Frameworks, Transition rules, Security implementations, etc.

    UI and Data modules must be like Plugins to Business Logic, were UI and Data both knows about the Business Logic but Business Logic will have no idea about the UI and the Data.

    UI ----> Business Logic <---- Data

  - Separating out the Testable UI code from the Non-Testable one

  - Testable Business Logic code without any dependency on UI, DataBase, Servers
  
  - The **most important aspect** of this architecture **won't surface until you receive the bugs and change list**. It is then you realize how efficiently and with ease one can pinpoint the location that needs to be looked in.
  
  - Another important aspect of this architecture is, **that it's is not dependent on any framework for its Reactiveness**, so we can implement the same philosophy in **any language or platform we want**. 
  
  
## TODO list
  1. Taking the routing out of ViewControllers into a separate file
  2. Formatting the ModelView further.
  
   
   ### Components of the app:
   I will only be taking in consideration all the important files that we will need to lay down this architecture. Other all files
are supportive files that are created here to support better programming.

#### Controllers

 1. EventsViewController


#### View Model

 1. EventsViewModel


#### Model

 1. Events


#### Worker

 1. EventsWorkerProtocol
 2. EventsWorker


#### Service

 1. EventsApi


#### Box

 1. Box
 2. Content
 
 
### Controllers

 1. EventsViewController


  *Controllers should never directly handle anything that deals with data and presentation, those are the jobs for
  Model and Views respectively.*

  **I will only try and explain the piece of code that shows the working of my Reactive Hybrid Architecture.**
  
  
  #### 1. EventsViewController
  
- lazy fileprivate var eventsList: [EventsViewModel.Response] = []
  eventsList is of type EventsViewModel.Response, which is a structure in EventsViewModel class
  Its responsible for providing the list of events to be displayed in table view.

- fileprivate var eventsViewModel = EventsViewModel(nil)
  eventsViewModel is of type EventsViewModel, which is important here to bind the listener.

- setListener() will be used to bind the listener to the Box type, its further explained in the Box type explanation section.


```
extension EventsViewController {
    
    internal func setListener() {
        self.eventsViewModel.isErrorFree.bind { [unowned self] in
            if $0.status == false {
                self.utility.showOkAlert(titleStr: "", msgStr: $0.message ?? "")
                return
            }
        }
    }
}
```
- This is the action which is binded to the listener, its further explained in the Box type explanation section.


```
extension EventsViewController {
    
    fileprivate func shootRequestFetch() {
        if !self.isPullToRefreshEnable {
            self.showSpinner(onView: self.view)
        }
        self.eventsViewModel.fetchEvents { (events) in
            DispatchQueue.main.async {
                self.removeSpinner()
                self.utility.refreshControl.endRefreshing()
            }
            if let _events = events {
                if _events.count > 0 {
                    self.eventsList = _events
                    DispatchQueue.main.async {
                        self.eventsTableView?.reloadData()
                    }
                }
            }
        }
    }
}
```

- fetchEvents is a method in EventsViewModel class that is responsible for fetching the data to be displayed in the list.


### View Model

 1. EventsViewModel

 *ViewModel is the intermediate layer between View/ViewController and the Model. ViewModel takeout what its not meant for ViewController, like data and presentation out of it. View/ViewController can access View Model but not other way around and similarly View Model can access Model but not other way around*.


 #### 1. EventsViewModel

- var isErrorFree: Box<Content> = Box(Content())
  isErrorFree which is of type Box which can hold Object of type Content

  - worker = EventsWorker(eventsWorkerProtocol: EventsApi())
   worker is of type EventsWorker with a constructor(ie. init) that can take a type that implements EventsWorkerProtocol
   This is very important here, as this accepts worker of any type that conforms to EventsWorkerProtocol, making the code more
   de-coupled.

  - fetchEvents is a method of the EventsApi struct that has implemented EventsWorkerProtocol, this will fetch the events of Events.
  

### Model

 1. Events
 
 *This is the Model which will be used by View Model, which then extract only the specific information that it needs to send to the View/ViewController*.
 


### Worker

 1. EventsWorkerProtocol
 2. EventsWorker


 *Workers are necessary pieces of puzzle that helps us build reusable components with workers and service objects*.

#### 1. EventsWorkerProtocol
```
protocol EventsWorkerProtocol {
    func fetchEvents(completionHandler: @escaping EventsWorkerHandler)
}

typealias EventsWorkerHandler = (EventsWorkerResult<Events>) -> Void

enum EventsWorkerResult<U> {
    case success([U])
    case failure(EventsWorkerFailure)
}

enum EventsWorkerFailure {
    case failed(String)
}

```

 **To explain EventsWorkerProtocol, I am creating a bottom up approach.**

```
 enum EventsWorkerFailure {
     case failed(String)
 }
```
- enum EventsWorkerFailure will deliver the failure message returned from Service


```
 enum EventsWorkerResult<U> {
     case success([U])
     case failure(EventsWorkerFailure)
 }
```
- enum EventsWorkerResult<U> will deliver the success and failure (failure is further encapsulate in EventsWorkerFailure enum) message returned from Service.
- "U" is the Generic cast for the type that is to be returned from Service.

```
typealias EventsWorkerHandler = (EventsWorkerResult<Events>) -> Void
```
- We are creating a closure with parameter of type EventsWorkerHandler<Events>, which we gonna return from Service class.


#### 2. EventsWorker
```
class EventsWorker {
    
    var eventsWorkerProtocol: EventsWorkerProtocol?
    
    init(eventsWorkerProtocol: EventsWorkerProtocol?) {
        self.eventsWorkerProtocol = eventsWorkerProtocol
    }
}
```
- EventsWorker will be initiated by taking in any type that implements EventsWorkerProtocol.

### Service

 1. EventsApi


 *Services are those types that implements WorkerProtocols, Services are used to fetch results which can be
 from Apis, DataBase , certain calculative processes, etc.*


#### 1. EventsApi
```
struct EventsApi: EventsWorkerProtocol {
    
    let url = "\(Utility.getSharedInstance().domain)dummy-response.json"
    let utility = Utility.getSharedInstance()
    
    func fetchEvents(completionHandler: @escaping EventsWorkerHandler) {
        utility.restClient.request(url: url, httpMethod: RestMethod.get.rawValue, header: nil, body: nil, param: nil, isBackground: false) { (response) in
            
            if let result = response as? RestResult {
                if result.error != nil {                    completionHandler(EventsWorkerResult.failure((EventsWorkerFailure.failed(ApiErrorMessage.EVENTS_FETCH_FAILED))))
                } else {
                    dump(result.result)
                    if let res = result.result as? [[String : Any]] {
                        let eventsArray = Mapper<Events>().mapArray(JSONArray: res)
                        completionHandler(EventsWorkerResult.success(eventsArray))
                    }
                }
            }
        }
    }
}

```

- As we can see that the return type of fetchEvents method is EventsWorkerHandler, we are returning EventsWorkerResult.success(eventsArray), now hows that being done....

  In the below mentioned code, we can see that we have defined a closure which takes EventsWorkerResult enum of Event type. This type Event
  becomes the type of the data which we will pass in success from Service.

```
  typealias EventsWorkerHandler = (EventsWorkerResult<Events>) -> Void

  enum EventsWorkerResult<U> {
      case success([U])
      case failure(EventsWorkerFailure)
  }


completionHandler(EventsWorkerResult.failure((EventsWorkerFailure.failed(ApiErrorMessage.EVENTS_FETCH_FAILED))))
```
- The above line of code is quite easy to understand, we are passing the error message to failure case which in turn is of type EventsWorkerFailure
```
  enum EventsWorkerFailure {
      case failed(String)
  }

```

### Box

 1. Box
 2. Content

*This is the magic black box, that helps in making this architecture reactive without using any 3rd party framework. I feel
its the architecture that should adopt to the code not the other way around. So saying that lets dig in.*

#### 1. Box
```
class Box<T> {
    
    typealias Listener = (T)-> Void
    var listener: Listener?
    
    var value: T
    {
        didSet
        {
            self.listener?(value)
        }
    }
    
    init(_ value: T)
    {
        self.value = value
    }
    
    func bind(listener: Listener?)
    {
        self.listener = listener
        self.listener?(value)
    }
}
```

#### Breaking it up
```
 typealias Listener = (T)-> Void
```
 - Listener is a closure which takes a parameter of type T. (ie. T is the place-holder for a type that we define while initialising Box instance)

```
 func bind(listener: Listener?)
 {
     self.listener = listener
     self.listener?(value)
 }
```
 - bind is used for binding the listener to the variable of type Box in the ViewModel from its respective ViewController.

 **Example:**
```
 
 class EventsViewModel {
 
 // Reactive properties
 var isErrorFree: Box<Content> = Box(Content()) // initialising the Box instance
    .
    .
    .
 }
```
```
extension EventsViewController {
    
    internal func setListener() {
        self.eventsViewModel.isErrorFree.bind { [unowned self] in               // binding the variable isErrorFree from EventsViewModel
            if $0.status == false {                                             // action to be taken when value is assigned to that variable isErrorFree
                self.utility.showOkAlert(titleStr: "", msgStr: $0.message ?? "") // Here we are raising an alert for no events in the list
                return
            }
        }
    }
}
```


#### Reaction Point
```
var value: T
{
    didSet
    {
        self.listener?(value)
    }
}
```
- This is responsible for making the listener react whenever a value is assigned to the variable of type Box.

**Example:**
```
  self.isErrorFree.value.message = message
  self.isErrorFree.value.status = false
```


 #### 2. Content
```
 struct Content
{
   var status: Bool = true
   var message: String? = nil
}
```
 - The main reason of creating this Content struct is to make Box take different types instead of just one.

 **Example:**
 
  *Instead of*
``` 
var isErrorFree: Box<Bool> = Box(false)
```
  *or*
```
var isErrorFree: Box<String> = Box("")
```
  *We can use Content type to define all the types that Box can hold*
```
var isErrorFree: Box<Content> = Box(Content())
```

So this is all about this architecture.
