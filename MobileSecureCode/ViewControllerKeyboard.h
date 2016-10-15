//
//  ViewControllerKeyboard.h
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerKeyboard : UIViewController


@property (nonatomic, retain) IBOutlet UITextField *myInput;
@property (nonatomic, retain) IBOutlet UITextView *logs;


- (IBAction) btnCloseClicked:(id)sender;

- (IBAction) btnActionClicked:(id)sender;
- (IBAction) btnClearClicked:(id)sender;


@end
