# iOSCleanArchitecture
iOS Clean Architecture with UIKit, MVVM, RxSwift

## High level overview

![alt text](https://github.com/dinhquan/iOSCleanArchitecture/blob/main/Images/HighLevel.png)

The whole design architecture is separated into 4 rings:
- **Entities**: Enterprise business rules
- **UseCases**: Application business rules
- **Data**: Network & Data persistent
- **Application**: UI & Devices

The most important rule is that the inner ring knows nothing about outer ring. Which means the variables, functions and classes (any entities) that exist in the outer layers can not be mentioned in the more inward levels.

## Detail overview

![alt text](https://github.com/dinhquan/iOSCleanArchitecture/blob/main/Images/DetailLevel.png)
