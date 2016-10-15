//
//  ViewControllerZero.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerZero.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerZero ()

@end

@implementation ViewControllerZero

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction) btnCloseClicked:(id)sender
{
    [self dismissViewControllerAnimated:FALSE completion:NULL];
}

- (IBAction) btnActionClicked:(id)sender
{
    NSString *msg = [NSString stringWithFormat:@"isJailbroken %d", [CommonFunc isJailbroken]];
    AppDelegate *myApp =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApp alert:@"Info" :msg];
}


@end
