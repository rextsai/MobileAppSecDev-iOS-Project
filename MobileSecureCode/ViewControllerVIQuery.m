//
//  ViewControllerVIQuery.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerVIQuery.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>

@interface ViewControllerVIQuery ()

@end

@implementation ViewControllerVIQuery

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
    NSString *msg = [NSString stringWithFormat:@"VIQuery=%@ by %@", [[[UIDevice currentDevice] identifierForVendor] UUIDString], [CommonFunc getDateStr]];
    
    [self AppendLog:msg];
}


- (void) saveImage:(UIImage *)imageToSave withInfo:(NSDictionary *)info
{
    // Get the image metadata (EXIF & TIFF)
    NSMutableDictionary * imageMetadata = [[info objectForKey:UIImagePickerControllerMediaMetadata] mutableCopy];
    
    // add (fake) GPS data
    CLLocationCoordinate2D coordSF = CLLocationCoordinate2DMake(37.732711,-122.45224);
    
    // arbitrary altitude and accuracy
    double altitudeSF = 15.0;
    double accuracyHorizontal = 1.0;
    double accuracyVertical = 1.0;
    NSDate * nowDate = [NSDate date];
    // create CLLocation for image
    CLLocation * loc = [[CLLocation alloc] initWithCoordinate:coordSF altitude:altitudeSF horizontalAccuracy:accuracyHorizontal verticalAccuracy:accuracyVertical timestamp:nowDate];
    
    // this is in case we try to acquire actual location instead of faking it with the code right above
    if ( loc ) {
        [imageMetadata setObject:[self gpsDictionaryForLocation:loc] forKey:(NSString*)kCGImagePropertyGPSDictionary];
    }
    
    // Get the assets library
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // create a completion block for when we process the image
    ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image %@ with metadata %@ to Photo Library",newURL,imageMetadata);
        }
    };
    
    // Save the new image to the Camera Roll, using the completion block defined just above
    [library writeImageToSavedPhotosAlbum:[imageToSave CGImage]
                                 metadata:imageMetadata
                          completionBlock:imageWriteCompletionBlock];
}

/**
 A convenience method to generate the {GPS} portion of a photo's EXIF data from a CLLLocation.
 
 @param location the location to base the NSDictionary on
 
 @return NSDictionary containing {GPS} block for a photo's EXIF data
 */
- (NSDictionary *) gpsDictionaryForLocation:(CLLocation *)location
{
    CLLocationDegrees exifLatitude  = location.coordinate.latitude;
    CLLocationDegrees exifLongitude = location.coordinate.longitude;
    
    NSString * latRef;
    NSString * longRef;
    if (exifLatitude < 0.0) {
        exifLatitude = exifLatitude * -1.0f;
        latRef = @"S";
    } else {
        latRef = @"N";
    }
    
    if (exifLongitude < 0.0) {
        exifLongitude = exifLongitude * -1.0f;
        longRef = @"W";
    } else {
        longRef = @"E";
    }
    
    NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
    
    // requires ImageIO
    [locDict setObject:location.timestamp forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
    [locDict setObject:latRef forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLatitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    [locDict setObject:longRef forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    [locDict setObject:[NSNumber numberWithFloat:exifLongitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    [locDict setObject:[NSNumber numberWithFloat:location.horizontalAccuracy] forKey:(NSString*)kCGImagePropertyGPSDOP];
    [locDict setObject:[NSNumber numberWithFloat:location.altitude] forKey:(NSString*)kCGImagePropertyGPSAltitude];
    
    return locDict;
    
}

@end
