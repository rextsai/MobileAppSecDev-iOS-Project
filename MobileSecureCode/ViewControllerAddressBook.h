//
//  ViewControllerAddressBook.h
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/ABAddressbook.h>

@interface ViewControllerAddressBook : UIViewController <ABNewPersonViewControllerDelegate,
ABPersonViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate>


@property (nonatomic, retain) IBOutlet UITextView *logs;
@property (nonatomic, readwrite) ABAddressBookRef *addressBook;


- (IBAction) btnCloseClicked:(id)sender;

- (IBAction) btnActionCheckAuthClicked:(id)sender;
- (IBAction) btnActionNewContactClicked:(id)sender;
- (IBAction) btnActionEditContactClicked:(id)sender;
- (IBAction) btnActionDeleteContactClicked:(id)sender;

- (IBAction) btnClearClicked:(id)sender;


@end
