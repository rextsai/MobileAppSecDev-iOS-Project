//
//  ViewControllerSetting.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerSetting.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerSetting ()

@end

@implementation ViewControllerSetting

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
    NSString *msg = [NSString stringWithFormat:@"Setting=%@ by %@", [[[UIDevice currentDevice] identifierForVendor] UUIDString], [CommonFunc getDateStr]];
    
    [self AppendLog:msg];
}




- (IBAction) btnGetAppSettingClicked:(id)sender
{
    //取得plist檔案路徑
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"secrets" ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [self AppendLog:[NSString stringWithFormat:@"filePath=%@", filePath]];
    //判斷plist檔案存在才讀取
    if ([fileManager fileExistsAtPath: filePath]) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSString *hash_password = [data objectForKey:@"hash_password"]; //從data中取值
        NSString *setting_lifes = [data objectForKey:@"setting_lifes"]; //從data中取值
        [self AppendLog:[NSString stringWithFormat:@"read hash_password=%@", hash_password]];
        [self AppendLog:[NSString stringWithFormat:@"read setting_lifes=%@", setting_lifes]];
        
    } else{
        [self AppendLog:@"file not exists"];
    }
}

- (IBAction) btnGetProgramSettingClicked:(id)sender
{
    NSString *APIKey = @"abcdef123456";
    [self AppendLog:[NSString stringWithFormat:@"read program APIKey=%@", APIKey]];
}


@end
