//
//  ViewControllerVIFormat.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerVIFormat.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerVIFormat ()

@end

@implementation ViewControllerVIFormat

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
    @try {
        printf ("%08x %08x %08x %08x %08x\n");
        //NSString *bug = @"%@%@";
        //NSLog(bug);
    }
    @catch ( NSException *e ) {
        [self AppendLog:[NSString stringWithFormat:@"Exception happened:%@", e.debugDescription]];
    }
}


@end
