//
//  ViewControllerZero.h
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerSSLPine : UIViewController <NSURLConnectionDelegate, NSURLSessionDelegate, UIWebViewDelegate>
{
    //NSURLConnection *urlconnection;
    NSURLSession *urlsession;
    NSOutputStream *outputStream;
    
    NSURLRequest *originRequest;
    BOOL isWebViewRequestAuthed;
}

@property (nonatomic, retain) IBOutlet UITextField *edit_url;
@property (nonatomic, retain) IBOutlet UISegmentedControl *edit_choice;
@property (nonatomic, retain) IBOutlet UISegmentedControl *edit_target;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UITextView *logs;

- (IBAction) btnCloseClicked:(id)sender;

- (IBAction) btnActionWebViewClicked:(id)sender;
- (IBAction) btnActionDataClicked:(id)sender;

- (IBAction) url_target_changed:(id)sender;





@end
