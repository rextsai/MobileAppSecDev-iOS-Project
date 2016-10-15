//
//  ViewControllerGeo.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerGeo.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerGeo ()

@end

@implementation ViewControllerGeo

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
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        AppDelegate *myApp =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [myApp alert:@"Info" : @"使用者未開放位置資訊!"];
        return;
    }
    
    if ([CLLocationManager locationServicesEnabled] == FALSE)
    {
        [self AppendLog:@"locationServicesEnabled=FALSE"];
        return;
    }
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    [self AppendLog:[NSString stringWithFormat:@"Location(%f,%f) by %@"
                     ,locationManager.location.coordinate.latitude
                     ,locationManager.location.coordinate.longitude,[CommonFunc getDateStr]]];
}


@end
