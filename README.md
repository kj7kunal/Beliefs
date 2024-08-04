# Beliefs App

Beliefs is an iOS application designed to help users keep track of their core beliefs and the evidence supporting them. This MVP version focuses on local storage and functionality.

## Features
- Create and manage personal beliefs
- Attach evidence to each belief
- View a personalized feed of beliefs
- Sort and filter beliefs by category
- Switch between dark and light modes
- View belief statistics
- Delete all data

## Development
- **Language:** Swift
- **Database:** SQLite
- **Backend:** Golang (planned)
- **Development Environment:** Xcode
- **Version Control:** Git
- **Testing:** XCTest for unit and UI tests

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/kj7kunal/Beliefs.git
   ```
2. Open the project in Xcode:
   ```
   cd Beliefs
   open Beliefs.xcodeproj
   ```
3. Build and run the app on the iOS Simulator or a connected device.

### Branching Strategy
- **develop:** Staging branch for new features and development
- **main:** Production branch

### Project Structure Overview
Main Directories and Files:
```
Beliefs/
├── Assets.xcassets/                  # Asset catalog for images and other resources
├── BeliefsApp.swift                  # Entry point of the app
├── MainTabView.swift                 # Main tab view containing navigation
├── BeliefsView.swift                 # View for displaying personal beliefs
├── NewBeliefView.swift               # View for adding new beliefs
├── EditBeliefView.swift              # View for editing existing beliefs
├── SettingsView.swift                # View for app settings
├── FeedView.swift                    # View for displaying all beliefs
├── CategoryFeedView.swift            # View for displaying beliefs by category
├── Database/
│   └── DatabaseManager.swift         # Manages SQLite database operations
├── Model/
│   ├── Belief.swift                  # Model for beliefs
│   ├── Category.swift                # Model for categories
│   └── UserPreferences.swift         # Model for user preferences
├── Components/
│   └── AutocompleteTextField.swift   # Component for text field with autocomplete suggestions
Beliefs.xcodeproj/                    # Xcode project file
BeliefsTests/                         # Unit test files
BeliefsUITests/                       # UI test files
```


### Testing Instructions
- Unit Tests (core functionality such as database operations)
  - Open the project in Xcode.
  - Select the BeliefsTests scheme. 
  - Press Cmd + U to run all unit tests.
- UI Tests (user interactions like adding, editing, and deleting beliefs)
  - Open the project in Xcode.
  - Select the BeliefsUITests scheme.
  - Press Cmd + U to run all UI tests.



## Contribution
All new development should occur in a new branch based on `develop` and merged via pull request.
1. Fork the repository.
2. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes and commit them with descriptive messages.
4. Push your changes to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Create a pull request from your branch to the develop branch of the main repository.

## Acknowledgments
- Swift and SwiftUI documentation for guidance
- [ChatGPT-4o](https://platform.openai.com/docs/models/gpt-4o) model for assistance in setting up and refining the project