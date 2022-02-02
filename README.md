### Digibank Light iOS

### Requirements

1. Language: Swift
2. Supporting versions: iOS 15.0 & above

### Dependencies

No dependencies

### Installation & Run

1. Clone the repository
2. Open `DigibankLight/DigibankLight.xcodeproj` file 
3. Use `⌘+U` to run unit tests
4. Use `⌘+R` to run app

### Folder structure

There are 4 folders in the project:
1. Services
2. UI 
3. UIComposer  
4. Extensions

### Services

Classes in `Services` folder are responsible for API communication and map the received JSON response into models.

### UI

Classes in `UI` folder are responsible for rendering UI with data received from Services.
UI is implemented through code and architecture used to implement UI is MVVM.

### UIComposer

Composes each module by injecting all dependencies it requires to fetch data and render.
SceneDelegate links module in navigation.

### Extensions

Classes in `Extensions` are reusable helpers to avoid duplications.
Eg: Loading indicator, error message, styling buttons etc

### Unit tests

Unit tests available for all Service classes, such as LoginService, RegistrationService etc, and followed TDD approach for implmentation of Service classes. 

### Known warnings

2 warnings

1. Warning in `groupTransactions` method of `DashboardViewModel.swift`.
2. Warning regarding UIScrollView contentSize ambiguity.



