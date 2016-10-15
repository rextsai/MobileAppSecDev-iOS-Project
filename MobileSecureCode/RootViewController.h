//
//  ViewController.h
//  MobileSecureCode
//
//  Created by Rex on 2016/7/21.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UITableViewDelegate>
{
    NSMutableArray *codes;
    int codes_rows;
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;

@end

