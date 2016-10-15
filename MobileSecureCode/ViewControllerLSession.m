//
//  ViewControllerLSession.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerLSession.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerLSession ()

@end

@implementation ViewControllerLSession

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
    AppDelegate *myApp =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *msg = [NSString stringWithFormat:@"isValidDate=%d by %@",[myApp isLoginDateValid], [CommonFunc getDateStr]];
    
    [self AppendLog:msg];
}

- (IBAction) btnSetDateClicked:(id)sender
{
    AppDelegate *myApp =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApp setLoginDate:[NSDate date]];
}

@end
