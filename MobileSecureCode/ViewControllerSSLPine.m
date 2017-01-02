//
//  ViewControllerZero.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerSSLPine.h"
#import "CommonFunc.h"
#import "AppDelegate.h"
#import <CFNetwork/CFNetwork.h>

@interface ViewControllerSSLPine ()

@end

//@implementation NSURLRequest (IgnoreSSL)
//+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
//{
//    return YES;
//}
//@end

@implementation ViewControllerSSLPine

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
 SSL Pinning
 
 1.由網站獲取公鑰，以利 https ssl ceriticate 認證時比對
   ex +'/BEGIN CERTIFICATE/,/END CERTIFICATE/p' <(echo | openssl s_client -showcerts -connect www.owasp.org:443) -scq > file.crt
 
 2.然後轉成 der
   openssl x509 -outform der -in owasp.crt -out owasp2.der
 
 3.附加為專案內容，以用於比對
 
 */

- (IBAction) btnCloseClicked:(id)sender
{
    [self dismissViewControllerAnimated:FALSE completion:NULL];
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

- (IBAction) url_target_changed:(id)sender
{
    if ([self edit_target].selectedSegmentIndex == 0){
        self.edit_url.text = @"https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning";
    }
    else if ([self edit_target].selectedSegmentIndex == 1)
        self.edit_url.text = @"https://www.google.com";
    else
        self.edit_url.text = @"https://gca.nat.gov.tw/web2/apply01.html";
}

- (IBAction) btnActionWebViewClicked:(id)sender
{
    [[self logs] setText:@""];
    AppDelegate *myApp =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlString = self.edit_url.text;
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url)
    {
        NSString *reason = [NSString stringWithFormat:@"Could not create URL from string %@", urlString];
        [myApp alert:@"Info" :reason];
        return;
    }
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    if (!theRequest)
    {
        NSString *reason = [NSString stringWithFormat:@"Could not create URL request from string %@", urlString];
        [myApp alert:@"Info" :reason];
        return;
    }
    
    isWebViewRequestAuthed = FALSE;
    [_webView loadRequest:theRequest];

}

- (IBAction) btnActionDataClicked:(id)sender
{
    [[self logs] setText:@""];
    AppDelegate *myApp =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlString = self.edit_url.text;
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url)
    {
        NSString *reason = [NSString stringWithFormat:@"Could not create URL from string %@", urlString];
        [myApp alert:@"Info" :reason];
        return;
    }

    //NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
    if (!theRequest)
    {
        NSString *reason = [NSString stringWithFormat:@"Could not create URL request from string %@", urlString];
        [myApp alert:@"Info" :reason];
        return;
    }
    
    
    //[theRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    urlsession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    
    [[urlsession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // response management code
        if (error)
        {
            [self AppendLog:[NSString stringWithFormat:@">> dataTask Error:%@", error.description]];
        }
        else
        {
            [self AppendLog:[NSString stringWithFormat:@">> dataTask got data %lu", data.length]];
        }
        
    }] resume];
    
    NSURLConnection *urlconnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (!urlconnection)
    {
        NSString *reason = [NSString stringWithFormat:@"URL connection failed for string %@", urlString];
        [myApp alert:@"Info" :reason];
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetPath = [documentsDirectory stringByAppendingFormat:@"/1.txt"];
    
    outputStream = [[NSOutputStream alloc] initToFileAtPath:targetPath append:YES];
    if (!outputStream)
    {
        NSString *reason = [NSString stringWithFormat:@"Could not create output stream at path %@", targetPath];
        [myApp alert:@"Info" :reason];
        return;
    }
    [outputStream open];
    [self AppendLog:@"Beginning Request"];
    [urlconnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [urlconnection start];
    
    /*
    CFStringRef url2 = (__bridge CFStringRef) self.edit_url.text;
    CFURLRef myURL2 = CFURLCreateWithString(kCFAllocatorDefault, url2, NULL);
    CFStringRef requestMethod = CFSTR("GET");
    
    CFHTTPMessageRef myRequest = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                                            requestMethod, myURL2, kCFHTTPVersion1_1);
    CFReadStreamRef myReadStream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, myRequest);
    
    CFReadStreamOpen(myReadStream);
    
    CFHTTPMessageRef myResponse = (CFHTTPMessageRef)CFReadStreamCopyProperty(myReadStream, kCFStreamPropertyHTTPResponseHeader);
    
    CFStringRef myStatusLine = CFHTTPMessageCopyResponseStatusLine(myResponse);
    
    unsigned myErrCode = (unsigned) CFHTTPMessageGetResponseStatusCode(myResponse);
    
    NSLog(@"myStatusLine=%@", myStatusLine);
    NSLog(@"myErrCode=%d", myErrCode);
     
     */
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    [self AppendLog:[NSString stringWithFormat:@">> NSURLConnection canAuthenticateAgainstProtectionSpace:%@", protectionSpace.authenticationMethod]];
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    [self AppendLog:@">> NSURLConnection didReceiveAuthenticationChallenge"];
    [self AppendLog:[[challenge protectionSpace] authenticationMethod]];

    NSLog(@"challenge.protectionSpace.host=%@", challenge.protectionSpace.host);
    
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];

    
    if (_edit_choice.selectedSegmentIndex == 1)
    {
        //Disable Pinning
        [self AppendLog:@">Disable Pinning"];
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
            
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        return;
    }
    //Enable Pinning
    [self AppendLog:@">Enable Pinning"];
    
    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust]){
        do
        {
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            if(nil == serverTrust)
            {
                [self AppendLog:@"serverTrust is nil"];
                break; // failed
            }
            
            OSStatus status = SecTrustEvaluate(serverTrust, NULL);
            
            if(!(errSecSuccess == status))
            {
                [self AppendLog:@"SecTrustEvaluate status is errSecSuccess"];
                break; // failed
            }
            
            SecCertificateRef serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
            
            if(nil == serverCertificate)
            {
                [self AppendLog:@"serverCertificate is nil"];
                break; // failed
            }
            
            CFDataRef serverCertificateData = SecCertificateCopyData(serverCertificate);
            
            //[(id)serverCertificateData autorelease];
            
            if(nil == serverCertificateData)
            {
                [self AppendLog:@"serverCertificateData is nil"];
                break; // failed
            }
            
            const UInt8* const data = CFDataGetBytePtr(serverCertificateData);
            
            const CFIndex size = CFDataGetLength(serverCertificateData);
            
            NSData* cert1 = [NSData dataWithBytes:data length:(NSUInteger)size];
            if(nil == cert1)
            {
                [self AppendLog:@"server cert is nil"];
                break; // failed
            }
            
            NSString *file ;
            
            if (_edit_target.selectedSegmentIndex == 2)
            {
                //GCA.der
                file = [[NSBundle mainBundle] pathForResource:@"gca2" ofType:@"der"];
            }
            else
            {
                file = [[NSBundle mainBundle] pathForResource:@"owasp" ofType:@"der"];
            }
            NSData* cert2 = [NSData dataWithContentsOfFile:file];
            if(nil == cert1 || nil == cert2)
            {
                [self AppendLog:@"local pinning cert is nil"];
                break; // failed
            }
            
            const BOOL equal = [cert1 isEqualToData:cert2];
            
            if(!equal){
                [self AppendLog:@"certs not equal"];
                break; // failed
            }
            
            [self AppendLog:@"certs are GOOD"];
            // The only good exit point
            return [[challenge sender] useCredential: [NSURLCredential credentialForTrust: serverTrust]
                                     forAuthenticationChallenge: challenge];
            
        } while(0);
    }
    // Bad dog
    [self AppendLog:@"BAD - cancelAuthenticationChallenge"];
    return [[challenge sender] cancelAuthenticationChallenge: challenge];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    //bytesRead += theData.length;
    [self AppendLog:[NSString stringWithFormat:@">> NSURLConnection didReceiveData %ld", (unsigned long)theData.length]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self AppendLog:@">> NSURLConnection-connectionDidFinishLoading"];
    // finished downloading the data, cleaning up
    [outputStream close];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self AppendLog:@">> NSURLConnection-didFailWithError"];
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    [self AppendLog:@">> URLSession didReceiveChallenge"];
    
    NSLog(@"challenge.protectionSpace.host=%@", challenge.protectionSpace.host);
    
    // Get remote certificate
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
    
    // Set SSL policies for domain name check
    NSMutableArray *policies = [NSMutableArray array];
    [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)challenge.protectionSpace.host)];
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    
    // Evaluate server certificate
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    BOOL certificateIsValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
    [self AppendLog:[NSString stringWithFormat:@"URLSession server certificateIsValid=%d", certificateIsValid]];
    
    // Get local and remote cert data
    NSData *remoteCertificateData = CFBridgingRelease(SecCertificateCopyData(certificate));
    
    NSString *file ;
    if (_edit_target.selectedSegmentIndex == 2)
    {
        //GCA.der
        file = [[NSBundle mainBundle] pathForResource:@"gca2" ofType:@"der"];
    }
    else
    {
        file = [[NSBundle mainBundle] pathForResource:@"owasp" ofType:@"der"];
    }
    NSData *localCertificate = [NSData dataWithContentsOfFile:file];
    
    // The pinnning check
    if ([remoteCertificateData isEqualToData:localCertificate] && certificateIsValid) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
        [self AppendLog:@"URLSession pinning completionHandler credential(GOOD)"];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        [self AppendLog:@"URLSession pinning completionHandler BAD(NULL)"];
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, NULL);
    }
}



- (BOOL)webView:(UIWebView *)awebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //for test for not-WebView
    if (request.URL == nil)
        return YES;
    
    NSString* scheme = [[request URL] scheme];
    //[self AppendLog:[NSString stringWithFormat:@"scheme = %@",scheme]];
    
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (isWebViewRequestAuthed == FALSE)
        {
            NSLog(@"using new NSURLConnection for webView.");
            originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [_webView stopLoading];
            return NO;
        }
        return YES;
    }
    //[self reflashButtonState];
    //[self freshLoadingView:YES];
    //NSURL *theUrl = [request URL];
    //self.currenURL = theUrl;
    
    //AppDelegate *myApp =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[myApp alert:@"Info" : @"ATS only allow https request"];
    //return NO;
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self AppendLog:@">> NSURLConnection didReceiveResponse"];
    
    /*
    NSLog(@"--------------didReceiveResponse dump NSHTTPCookieStorage------------\n");
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        NSLog(@"name: '%@'\n",   [cookie name]);
        NSLog(@"value: '%@'\n",  [cookie value]);
        NSLog(@"domain: '%@'\n", [cookie domain]);
        NSLog(@"path: '%@'\n",   [cookie path]);
        NSLog(@"HttpOnly,Secure: '%d,%d'\n",   [cookie isHTTPOnly], [cookie isSecure]);
    }*/
    
    //for URLConnection method
    //if (connection == connection)
    //    return;
    
    isWebViewRequestAuthed = YES;
    //webview 重新加载请求。
    [_webView loadRequest:originRequest];
    [connection cancel];
}

/*
- (void)connection:(NSURLConnection *)connection
willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self AppendLog:@">> NSURLConnection willSendRequestForAuthenticationChallenge"];
    
    
    //work good for GCA
    //[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    
    //will makes all ssl fail
    //[[challenge sender] cancelAuthenticationChallenge:challenge];
    
    //will make ssl-pinning OFF
    //[[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
    
    //[[challenge sender] rejectProtectionSpaceAndContinueWithChallenge:challenge];
    

    //if (self.edit_target.selectedSegmentIndex==2)
    //{
        //GCA
        //[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        //return;
    //}
    
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    if (_edit_choice.selectedSegmentIndex == 1)
    {
        //Disable Pinning
        [self AppendLog:@">Disable Pinning"];
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
            
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        return;
    }
    //Enable Pinning
    [self AppendLog:@">Enable Pinning"];
    
    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust]){
        do
        {
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            if(nil == serverTrust)
            {
                [self AppendLog:@"serverTrust is nil"];
                break; // failed
            }
            
            OSStatus status = SecTrustEvaluate(serverTrust, NULL);
            
            if(!(errSecSuccess == status))
            {
                [self AppendLog:@"SecTrustEvaluate status is errSecSuccess"];
                break; // failed
            }
            
            SecCertificateRef serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
            
            if(nil == serverCertificate)
            {
                [self AppendLog:@"serverCertificate is nil"];
                break; // failed
            }
            
            CFDataRef serverCertificateData = SecCertificateCopyData(serverCertificate);
            
            //[(id)serverCertificateData autorelease];
            
            if(nil == serverCertificateData)
            {
                [self AppendLog:@"serverCertificateData is nil"];
                break; // failed
            }
            
            const UInt8* const data = CFDataGetBytePtr(serverCertificateData);
            
            const CFIndex size = CFDataGetLength(serverCertificateData);
            
            NSData* cert1 = [NSData dataWithBytes:data length:(NSUInteger)size];
            if(nil == cert1)
            {
                [self AppendLog:@"server cert is nil"];
                break; //failed
            }
            
            NSString *file ;
            
            if (_edit_target.selectedSegmentIndex == 2)
            {
                //GCA.der
                file = [[NSBundle mainBundle] pathForResource:@"gca2" ofType:@"der"];
            }
            else
            {
                file = [[NSBundle mainBundle] pathForResource:@"owasp" ofType:@"der"];
            }
            NSData* cert2 = [NSData dataWithContentsOfFile:file];
            if(nil == cert1 || nil == cert2)
            {
                [self AppendLog:@"local pinning cert is nil"];
                break; // failed
            }
            
            const BOOL equal = [cert1 isEqualToData:cert2];
            
            if(!equal){
                [self AppendLog:@"certs not equal"];
                break; // failed
            }
            
            [self AppendLog:@"certs are GOOD"];
            // The only good exit point
            return [[challenge sender] useCredential: [NSURLCredential credentialForTrust: serverTrust]
                          forAuthenticationChallenge: challenge];
            
        } while(0);
    }
    // Bad dog
    [self AppendLog:@"BAD - cancelAuthenticationChallenge"];
    return [[challenge sender] cancelAuthenticationChallenge: challenge];
    
}*/

- (void)connection:(NSURLConnection *)connection
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self AppendLog:@">> NSURLConnection didCancelAuthenticationChallenge"];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    [self AppendLog:@">> NSURLConnection connectionShouldUseCredentialStorage"];
    return YES;
}

@end
