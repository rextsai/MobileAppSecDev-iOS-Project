//
//  RootViewController.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/21.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "RootViewController.h"
#import "iCustomCellRowType.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize myTableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    codes = [[NSMutableArray alloc] init];
    
    //4**名稱：Implement Anti-tamper Techniques
    //iOS反破解偵測程式碼
    [codes addObject:@"1.反破解偵測程式碼\n  CPO-03"];
    
    [codes addObject:@"2.SSL pinning\n  CPF-18,CPM-05,iOS-04"];
    
    //12**名稱：Limit use of UUID
    [codes addObject:@"3.Limit use of UUID\n  CPL-04"];
    
    //13**名稱：Treat  geo-location data carefully
    [codes addObject:@"4.Treat geo-location data carefully\n  CPE-04"];
    
    //14**名稱：Institute local session timeout
    [codes addObject:@"5.Institute local session timeout\n  CPM-03"];
    
    //16**名稱：Protect application settings
    [codes addObject:@"6.Protect application settings\n  CPF-17"];
    
    //17**名稱：Hide account numbers and use tokens
    [codes addObject:@"7.Hide account numbers and use tokens\n  CPE-05"];
    
    //18**名稱：Implement secure network transmission of sensitive data
    //SSL
    
    //20**名稱：Avoid Caching app data
    [codes addObject:@"8.Avoid Caching app data\n  CPF-09"];
    
    //23**名稱：Carefully manage debug logs
    [codes addObject:@"9.Carefully manage debug logs\n  CPF-10"];

    //21**名稱：Avoid Crash logs
    //[codes addObject:@"9.Avoid Crash logs"];
    [codes addObject:@"10.Avoid Crash logs\n  CPF-11"];
    
    //24**名稱：Be aware of the keyboard cache
    [codes addObject:@"11.Be aware of the keyboard cache\n  CPF-14"];
    
    //25**名稱：Be aware of copy paste
    [codes addObject:@"12.Be aware of copy paste\n  CPF-15"];
    
    //[NowSecure]iOS.2 避免快取應用程式截圖（Avoid Cached Application Snapshots）
    [codes addObject:@"13.避免快取應用程式截圖\n  iOS-02"];

    //28**名稱：(iOS) use the keychain carefully
    [codes addObject:@"14.use the keychain carefully\n  iOS-01"];

    //29**名稱：(iOS) use automatic reference counting
    [codes addObject:@"15.use automatic reference counting\n  iOS-03"];
    
    //19-0**名稱：validate input from client
    //Buffer overflow…
    [codes addObject:@"16.validate input:Buffer overflow\n  CPQ-01,CPQ-02"];
    //Integer overflow and underflow
    [codes addObject:@"17.validate input:Integer overflow and underflow\n  CPQ-04"];
    //Format String Attacks
    [codes addObject:@"18.validate input:Format String Attacks\n  CPQ-09"];
    //SQL Injection
    [codes addObject:@"19.validate input:SQL Injection\n  CPQ-05"];
    //Query parameterization
    [codes addObject:@"20.validate input:Query parameterization\n  CPQ-03"];
    //Command Injection
    [codes addObject:@"21.validate input:Command Injection\n  CPQ-06"];
    //XML injection
    [codes addObject:@"22.validate input:XML injection\n  CPQ-08"];
    
    //22**名稱：Limit caching of username
    [codes addObject:@"23.Limit caching of username\n  CPF-08"];
    
    //26**名稱：Prevent farming and clickjacking
    [codes addObject:@"24.Address Book 手機聯絡人\n   CPE-03"];
    
    //27**名稱：Protect against csrf form tokens
    [codes addObject:@"25.Protect against csrf form tokens"];
    
    //NEW**名稱：XSS
    //https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)
    
    //5**名稱：Securely Store Sensitive Data in RAM
    //不能以檔案方式存放。
    //不要用字串直接存放
    //建議用char array or byte array存放，以避免容易被駭客取得。
    //[codes addObject:@"2.Securely Store Sensitive Data in RAM"];
    
    //6UNDERSTAND SECURE DELETION OF DATA
    //說明即可，不需程式碼
    
    //IMPLEMENT SECURE DATA STORAGE
    //說明即可，不需程式碼
    //iOS: DataProtection explain.
    
    //AVOID QUERY STRING FOR SENSITIVE DATA
    //說明即可，不需程式碼
    
    //USE SECURE SETTING FOR COOKIES
    //Cooike:Secure Only Tag.
    
    //FULLY VALIDATE SSL/TLS
    
    //PROTECT AGAINST SSL DOWNGRADE ATTACKS
    
    
    //7-10**名稱：Secure Data Transfer with SSL
    
    //11**名稱：Protect against SSL-Strip

    //NEW**名稱：加密方法說明與範例
    
    //[iOS Security Guide]iOS App 程式碼簽章（code sign）
    codes_rows = (int)codes.count;
    [myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return codes_rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"iDownloadCustomCellRowType";
    iCustomCellRowType *cell = (iCustomCellRowType *)
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[iCustomCellRowType alloc] initWithFrame: CGRectZero];
    }
    int row = (int)indexPath.row;
    
    cell.primaryLabel.text = [codes objectAtIndex:row];
    
    //UIImageView *newV = [[UIImageView alloc] init];
    //[newV setContentMode : UIViewContentModeScaleAspectFit];
    //[newV setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:download.thumbUrl]]]];
    //newV.frame = CGRectMake(2,2,84,84);
    //[newV setClipsToBounds:TRUE];
    //[newV setContentMode:UIViewContentModeScaleAspectFit];
    
    //[cell.contentView addSubview:newV];
    
    //    [cell.btn_Retry setHidden:TRUE];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) resetUI
{
    [[self myTableView] reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *segue_id = [NSString stringWithFormat:@"segue%ld", (long)indexPath.row];
    [self performSegueWithIdentifier:segue_id sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    headerView.backgroundColor=[[UIColor redColor]colorWithAlphaComponent:0.5f];
    headerView.layer.borderColor=[UIColor blackColor].CGColor;
    headerView.layer.borderWidth=1.0f;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,100,20)];
    
    headerLabel.textAlignment = NSTextAlignmentRight;
    headerLabel.text = @"Actions ";
    //headerLabel.textColor=[UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:headerLabel];
    /*
    
    UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    
    headerLabel1.textAlignment = NSTextAlignmentRight;
    headerLabel1.text = @"Actions";
    headerLabel.textColor=[UIColor whiteColor];
    headerLabel1.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:headerLabel1];*/
    
    return headerView;
    
}


@end
