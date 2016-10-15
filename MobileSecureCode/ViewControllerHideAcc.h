//
//  ViewControllerHideAcc.h
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerHideAcc : UIViewController <UITextFieldDelegate>


@property (nonatomic, retain) IBOutlet UITextField *edit_input;
@property (nonatomic, retain) IBOutlet UITextView *logs;
@property (nonatomic, retain) IBOutlet UILabel *label_Account, *label_Token;


- (IBAction) btnCloseClicked:(id)sender;

- (IBAction) btnActionClicked:(id)sender;
- (IBAction) btnClearClicked:(id)sender;


@end
