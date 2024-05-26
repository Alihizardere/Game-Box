# Game Box
Welcome to Game Box! This app allows users to browse a variety of games, explore their details, perform searches and add them to favorites.

## Table of Contents
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Listings - Browse Games](#listings---browse-games)
    - [Game Details](#game-details)
    - [Favorite Games](#favorite-games)
- [Improvements](#improvements)

## Features
### Browse Games:
Explore various games.
(Note that none of the games are real, they are provided by a fake api).

### Search Games:
 You can search for the game you want.
 
### Favorite Games:
You can view and un-favorite your favorite games.
 
### Check the details:
Check the details and abilities of your selected game. 

## Screenshots

| Image 1 | Image 2 | Image 3 |
|---------|---------|---------|
![image1](https://github.com/Alihizardere/denemess/assets/79551625/2bd5320b-210e-46e7-9e5c-6265a235f3ca)|  ![image2](https://github.com/Alihizardere/denemess/assets/79551625/cd2c2f7a-e23c-4bb5-81f9-32d2596faf29)| ![image3](https://github.com/Alihizardere/denemess/assets/79551625/2e549de2-bbfb-4ab7-b65a-8672d408467e) |
| Homepage | Search | Detailpage |
## Screenshots

| Image 4 | Image 5 | Image 6 |
|---------|---------|---------|
![image1](https://github.com/Alihizardere/denemess/assets/79551625/505ecc79-7551-4e0a-9444-38c39bb97eb0)|  ![image2](https://github.com/Alihizardere/denemess/assets/79551625/c51fd145-9547-44bd-8ec1-27f301bbd64a)| ![image3](https://github.com/Alihizardere/denemess/assets/79551625/3afe3493-eeba-4280-bb11-a8e585dcf99a) |
| Detail | Skills | Trailer |

## Tech Stack
- Xcode: Version 15.3
- Language: Swift 5.10
- Dependency Manager: SPM

## Architecture
![mvvm](https://github.com/Alihizardere/denemess/assets/79551625/d80cf99a-f971-400d-9736-9d6e0dc3e8c9)

When developing the Crypto Project, the MVVM (Model-View-ViewModel) architecture is used for these fundamental reasons:
- **Net Separation:** MVVM clearly separates the user interface (View), business logic (Model) and connectivity (ViewModel), which makes the code more modular and maintainable.
- **Data Binding:** MVVM uses data binding between View and ViewModel. This reduces code repetition, makes UI code cleaner, and enables View to get data from ViewModel and ViewModel to provide data to View.
- **Scalability:** MVVM offers a modular structure and allows new features or changes to be easily added. This makes the application scalable and streamlines the development process.

## Getting Started
### Prerequisites
Before you begin, ensure you have the following:
- Xcode installed

Also, make sure that these dependencies are added in your project's target:
- [Kingfisher](https://github.com/onevcat/Kingfisher): Kingfisher is a lightweight and pure Swift library for downloading and caching images from the web.
- [Alamofire](https://github.com/Alamofire/Alamofire): Alamofire is an elegant HTTP networking library written in Swift.

### Installation
1. Clone the repository:
```bash
git clone https://github.com/Alihizardere/Game-Box
```

2. Open the project in Xcode:
```bash
cd Game Box
open GameBox.xcodeproj
```
3. Add required dependencies using Swift Package Manager:
```bash
- Kingfisher
- Alamofire 
```

4. Build and run the project.

#### Usage
#### Listings - Browse Games
- Open the app on your simulator or device.
- Browse games, tap on the relevant product to go to the game detail.
- Search for the game you want.

#### Game Details
- Check the details and capabilities of your chosen game. 
- You can watch screenshots and trailer of the game.
- You can add it to your favorites.

#### Favorite Games:
You can view and un-favorite your favorite games.

## Improvements
- Activity indicator and smooth animations can be added for a better user experience.
- Pagination could be done and more products could be shown.
