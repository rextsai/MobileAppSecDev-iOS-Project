//
//  ViewControllerVIInteger.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerVIInteger.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerVIInteger ()

@end

@implementation ViewControllerVIInteger

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
    [self AppendLog:[NSString stringWithFormat:@"INT32_MAX=%d", INT32_MAX]];
    [self AppendLog:[NSString stringWithFormat:@"INT32_MAX+1=%d", INT32_MAX+1]];
    [self AppendLog:[NSString stringWithFormat:@"INT32_MAX+1+INT32_MAX=%d", INT32_MAX+1+INT32_MAX]];
    [self AppendLog:[NSString stringWithFormat:@"INT32_MIN=%d", INT32_MIN]];
    [self AppendLog:[NSString stringWithFormat:@"INT32_MIN-1=%d", INT32_MIN-1]];
    [self AppendLog:[NSString stringWithFormat:@"INT32_MIN-1-INT32_MIN=%d", INT32_MIN-1-INT32_MIN]];
}


@end
