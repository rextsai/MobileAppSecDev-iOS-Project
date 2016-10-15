//
//  AppDelegate.h
//  MobileSecureCode
//
//  Created by Rex on 2016/7/21.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSDate *loginDate;
    BOOL securedSnapshots;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readwrite) UIImageView *backgroundImage;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)alert:(NSString*) alertTitle : (NSString*) alertMessage;

- (void) setLoginDate: (NSDate *)indate;
- (BOOL) isLoginDateValid;
- (void) setSecureSnapshots: (BOOL) flag;



@end

