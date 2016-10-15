//
//  ViewControllerKeychain.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerKeychain.h"
#import "AppDelegate.h"
#import "ChristmasConstants.h"
#import "KeychainWrapper.h"

@interface ViewControllerKeychain ()

@end

@implementation ViewControllerKeychain

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

- (IBAction) btnActionSaveUsernameClicked:(id)sender
{
    if ([self.edit_username.text length] > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:self.edit_username.text forKey:USERNAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self AppendLog:@"Wrote User Name to NSUserDefaults"];
    }
    else{
        [self AppendLog:@"User Name cannot empty"];
    }
}

- (IBAction) btnActionReadUsernameClicked:(id)sender
{
    NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    self.edit_username.text = user;
    [self AppendLog:[NSString stringWithFormat:@"Read User Name=%@", user]];
}

- (IBAction) btnActionSavePasswordClicked:(id)sender
{
    if ([self.edit_password.text length] > 0) {
        
        NSUInteger fieldHash = [self.edit_password.text hash];
        NSString *fieldString = [KeychainWrapper securedSHA256DigestHashForPIN:fieldHash];
        [self AppendLog:[NSString stringWithFormat:@"Password Hash=%@", fieldString]];
        
        // Save PIN hash to the keychain (NEVER store the direct PIN)
        if ([KeychainWrapper createKeychainValue:fieldString forIdentifier:PIN_SAVED]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PIN_SAVED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self AppendLog:@"Password saved successfully to Keychain!!"];
        }
        else
            [self AppendLog:@"Password not saved to Keychain!!"];
    }
    else{
        [self AppendLog:@"Password cannot empty"];
    }
}

- (IBAction) btnActionReadPasswordClicked:(id)sender
{
    if ([self.edit_password.text length] > 0) {
        
        NSUInteger fieldHash = [self.edit_password.text hash]; // Get the hash of the entered PIN, minimize contact with the real password
        // 3
        if ([KeychainWrapper compareKeychainValueForMatchingPIN:fieldHash]) { // Compare them
            [self AppendLog:@"Password Compared VALID!"];
        } else {
            [self AppendLog:@"Wrong Password"];
        }
    }
    else{
        [self AppendLog:@"Password cannot empty"];
    }
}


@end
