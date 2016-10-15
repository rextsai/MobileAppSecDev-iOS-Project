//
//  ViewControllerHideAcc.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerHideAcc.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerHideAcc ()

@end

@implementation ViewControllerHideAcc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) AppendLog:(NSString*) msg
{
    NSLog(@"%@", msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        /* Do UI work here */
        NSString *txt = self.logs.text;
        [self.logs setText:[[txt stringByAppendingString:@"\n"] stringByAppendingString:msg]];
    });
}

- (IBAction) btnCloseClicked:(id)sender
{
    [self dismissViewControllerAnimated:FALSE completion:NULL];
}

- (IBAction) btnClearClicked:(id)sender
{
    [self.logs setText:@""];
}

- (IBAction) btnActionClicked:(id)sender
{
    NSString *str = self.edit_input.text;
    if (str.length != 10)
    {
        [self AppendLog:@"You need input complete Taiwan ID!"];
        str = @"A123456789";
        [self AppendLog:@"Assume Taiwan ID=A123456789"];
    }
    self.label_Account.text = [str stringByReplacingCharactersInRange:NSMakeRange(4, 3)  withString:@"***"];
    [self AppendLog:[NSString stringWithFormat:@"Hide Account with %@", self.label_Account.text]];
    //int value = [[str substringWithRange:NSMakeRange(1,9)] intValue];
    //NSLog(@"%d",value);
    NSUInteger r = arc4random_uniform(1000000000);
    self.label_Token.text = [NSString stringWithFormat:@"%09lu",(unsigned long)r];
    [self AppendLog:[NSString stringWithFormat:@"Token with Random=%@", self.label_Token.text]];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return TRUE;
    }
    if (range.location == 0)
    {
        if (string.length == 1)
        {
            return [[string stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]] isEqualToString:@""];
        }
        return NO;
    }
    NSInteger strLength = textField.text.length- range.length+ string.length;
                    
    if (strLength <= 10)
    {
        return [[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] isEqualToString:@""];
    }
    return NO;
}


@end
