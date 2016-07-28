//
//  AppDelegate.h
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "lsTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic          ) UIWindow           *window;
@property (nonatomic,copy             ) NSString           * username;
@property (nonatomic,strong           ) lsTabBarController * tvc;

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

