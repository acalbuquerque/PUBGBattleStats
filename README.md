# COMMENTS

# Running
### Requirements
* XCode Version 10.2.1 -> https://developer.apple.com/xcode/
* CocoaPods 1.7.0.beta.1 -> https://github.com/CocoaPods/CocoaPods
 
 ### About the App
 
 Yeah...this app it's a PUBG(PlayerUnknown's Battlegrounds) Stats Client using the official game API. 
 Well, PUBG is an online multiplayer battle royale game developed and published by PUBG Corporation and is one of the best-selling and most-played video games of all time, selling over fifty million copies worldwide by June 2018, with over 400 million players in total when including the mobile version.
 
 I had this idea to create this project for fun and to a study purpouse.
 And yes, of course, I like also to play this game. =)
 
### Intructions to setup the project

* Execute the following command ```pod install``` on the root directory, the file *BattleStats.xcworkspace* will be created.
* Open the file *BattleStats.xcworkspace* with XCode and then run the target ```BattleStats```.
* Replace the ```apiKey``` constant with a valid one in ```Constants```  file. (https://developer.pubg.com/)

### Tests Instructions ###

Run the following targets ```BattleStatsTests```

If fastlane is available, run ```fastlane test``` on the source code root directory using terminal.

Also, it's possible to run the SwiftLint using Fastlane, run ```fastlane lint``` on terminal.

# Architecture
This app is based on Clean Architecture Approach, mainly VIPER pattern but have a small concept of MVVM. 

VIPER is an acronym for View, Interactor, Presenter, Entity and Router. 
This 5 layers allow us to have a good separation of concerns and support the project to achieve 4 main pilars: Readability, Maintenability, Scalability, Testability.

* The Builder basicaly is the class constructor.
* The view is only responsible to rendering UI stuffs (she is dumb). 
* All calculation, formatation and the view communication is responsalibility of the Presenter.
* All interation(local and server requests) is with the Interactor and in this particular case, I created a Worker to handle the request jobs....so, the interactor it's basically a Facade pattern. Also, it's not mandatory for some classes.
* The entities are the Codable Models.
* The router knows were to go.

The code is divided into 4 folders for a better localization.
I also created a Environment file to allow the project to have at least 3 EnvTypes (.staging, .production and tests). And the App file use that to Start the project.
Also I created some extensions and Enums to make everything more reachable (inside Util folder).

# App Visual Flow 
-------------------------------------------------------------------
![alt text](https://i.imgur.com/MEvAhei.png)                                                                           
-------------------------------------------------------------------

# Third Party Libraries
### For the development:
1. RXSwift:
Reactive Programming in Swift. Rx enables building apps in a declarative way. https://github.com/ReactiveX/RxSwift

2. Eureka:
Used to make the form easier

2. Kingfisher:
Used to render images easier

4. JGProgressHUD:
Just a HUD

5. Others:
ReachabilitySwift, Sniffer

### Unit Tests

1. I could used Quick and Nimble to help me to handle and improve the UnitTests but I just used XCTestFramework.

# Improvements
For the features in the app, should be a good improvement having the last matches stats and info. For the Tests part, UITests will be the next thing for automated testing that included several bug cases.


PS: If you have some questions about this project, please contact me on twitter @acalbuquerque

Thank you,
Antonio Netto
