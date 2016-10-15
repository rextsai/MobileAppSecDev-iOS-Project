//
//  ViewControllerKeychain.h
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerKeychain : UIViewController


@property (nonatomic, retain) IBOutlet UITextView *logs;
@property (nonatomic, retain) IBOutlet UITextField *edit_username, *edit_password;


- (IBAction) btnCloseClicked:(id)sender;

- (IBAction) btnActionSaveUsernameClicked:(id)sender;
- (IBAction) btnActionReadUsernameClicked:(id)sender;
- (IBAction) btnActionSavePasswordClicked:(id)sender;
- (IBAction) btnActionReadPasswordClicked:(id)sender;

- (IBAction) btnClearClicked:(id)sender;


@end
