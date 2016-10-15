//
//  ViewControllerVISQL.h
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface ViewControllerVISQL : UIViewController
{
    sqlite3 *database;
}

@property (nonatomic, retain) IBOutlet UITextView *logs;
@property (nonatomic, retain) IBOutlet UITextField *edit_key;
@property (nonatomic, retain) IBOutlet UITextField *edit_value;


- (IBAction) btnCloseClicked:(id)sender;

- (IBAction) cleanTable :(id)sender;
- (IBAction) insertUnsafe : (id) sender;
- (IBAction) insertSafe : (id) sender;
- (IBAction) btnClearClicked:(id)sender;
- (IBAction) selectTable :(id)sender;


@end
