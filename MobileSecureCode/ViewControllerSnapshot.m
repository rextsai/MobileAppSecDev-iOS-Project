//
//  ViewControllerSnapshot.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerSnapshot.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerSnapshot ()

@end

@implementation ViewControllerSnapshot

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

- (IBAction) clearImage
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
            [view removeFromSuperview];
    }
}

- (IBAction) btnActionClicked:(id)sender
{
    AppDelegate *myApp =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApp setSecureSnapshots:TRUE];
    [self AppendLog:@"[myApp setSecureSnapshots:TRUE];"];
    
    UIImageView *myBanner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secure-image.png"]];
    [self.view addSubview:myBanner];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(clearImage) userInfo:nil repeats:NO];
}

- (IBAction) btnAction2Clicked:(id)sender
{
    AppDelegate *myApp =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [myApp setSecureSnapshots:FALSE];
    [self AppendLog:@"[myApp setSecureSnapshots:FALSE];"];
}


@end
