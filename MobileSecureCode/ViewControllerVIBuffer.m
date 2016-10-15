//
//  ViewControllerVIBuffer.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerVIBuffer.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerVIBuffer ()

@end

@implementation ViewControllerVIBuffer

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
    //NSString *msg = [NSString stringWithFormat:@"VIBuffer=%@ by %@", [[[UIDevice currentDevice] identifierForVendor] UUIDString], [Server getDateStr]];

    int len = (int)self.myInput.text.length;
    char buf[len+1];
    [self AppendLog:[NSString stringWithFormat:@"buf[].length=%d=InputText.length", len]];
    //strncpy
    strncpy(buf,  [self.myInput.text UTF8String] , len);
    [self AppendLog:[NSString stringWithFormat:@"strncpy: buf is %s(%lu)", buf, strlen(buf)]];
    //strlpy
    strlcpy(buf, [self.myInput.text UTF8String] , len);
    [self AppendLog:[NSString stringWithFormat:@"strlcpy: buf is %s(%lu)", buf, strlen(buf)]];
    //[self AppendLog:msg];
    
    [self AppendLog:[NSString stringWithFormat:@"validEmail is %d",[CommonFunc validEmail:self.myInput.text]]];
}


@end
