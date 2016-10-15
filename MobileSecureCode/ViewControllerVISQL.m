//
//  ViewControllerVISQL.m
//  MobileSecureCode
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ViewControllerVISQL.h"
#import "CommonFunc.h"
#import "AppDelegate.h"

@interface ViewControllerVISQL ()

@end

@implementation ViewControllerVISQL

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self openDatabase];
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
    NSString *msg = [NSString stringWithFormat:@"VISQL=%@ by %@", [[[UIDevice currentDevice] identifierForVendor] UUIDString], [CommonFunc getDateStr]];
    
    [self AppendLog:msg];
}


-(BOOL)createDatabase {
    NSString *ddlPath = [[NSBundle mainBundle] pathForResource:@"/Setting" ofType:@"sql"];
    //NSLog(@"createDatabase %@", ddlPath);
    NSString *ddl = [NSString stringWithContentsOfFile:ddlPath encoding:NSUTF8StringEncoding error:NULL];
    if (sqlite3_exec(database, [ddl UTF8String], nil,nil,nil) != SQLITE_OK) {
        sqlite3_close(database);
        return NO;
    }
    return YES;
}
-(BOOL)openDatabase {
    NSLog(@"openDatabase");
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"Setting.sqlite"];
    NSLog(@"dbPath=%@", dbPath);
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return NO;
    }
    BOOL res = [self createDatabase];
    return res;
}

-(int)getSettingCount {
    int count = 0;
    const char* sqlStatement = "SELECT COUNT(*) FROM Setting";
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK ) {
        //Loop through all the returned rows (should be just one)
        while( sqlite3_step(statement) == SQLITE_ROW ) {
            count = sqlite3_column_int(statement, 0);
        }
    }else  {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    // Finalize and close database.
    sqlite3_finalize(statement);
    return count;
}

-(BOOL)executeSQL:(NSString*)sql {
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database,[sql UTF8String],-1,&statement,NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) != SQLITE_DONE) {
            return NO;
        }
    }
    else
        return NO;
    
    return YES;
}

- (IBAction) insertUnsafe : (id) sender
{
    BOOL rst = [self executeSQL:[NSString stringWithFormat:@"INSERT INTO Setting(SKey,SValue) VALUES('%@','%@')", self.edit_key.text, self.edit_value.text]];
    
    [self AppendLog:[NSString stringWithFormat:@"insertUnsafe rst:%d, total=%d", rst, [self getSettingCount]]];
}

- (IBAction) insertSafe : (id) sender
{
    sqlite3_stmt *statement;
    BOOL DONE = TRUE;
    char *sql = "INSERT INTO Setting(SKey,SValue) VALUES(?,?)";
    
    if (sqlite3_prepare_v2(database,sql,-1,&statement,NULL) == SQLITE_OK) {
        sqlite3_bind_text(statement,1,[self.edit_key.text UTF8String],-1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,2,[self.edit_value.text UTF8String],-1, SQLITE_TRANSIENT);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            DONE = FALSE;
            NSLog(@"Error");
        }
    }
    else
        DONE = FALSE;
    sqlite3_finalize(statement);
    
    [self AppendLog:[NSString stringWithFormat:@"insertSafe rst:%d, total=%d", DONE, [self getSettingCount]]];
}

- (IBAction) cleanTable :(id)sender
{
    BOOL rst = [self executeSQL:@"DELETE FROM Setting"];
    
    [self AppendLog:[NSString stringWithFormat:@"cleanTable rst:%d, total=%d", rst, [self getSettingCount]]];
}

-(NSString *)getColumnText:(sqlite3_stmt*) statement columnIndex:(int)columnIndex {
    char *raw = (char*) sqlite3_column_text(statement,columnIndex);
    if (raw==NULL) return nil;
    else return  [NSString stringWithUTF8String:raw];
}

- (IBAction) selectTable :(id)sender
{
    NSLog(@"fetchSetting");
    sqlite3_stmt *selectStatement;
    char *selectSql = "SELECT * FROM Setting";
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement)==SQLITE_ROW) {
            [self AppendLog:[NSString stringWithFormat:@"SKey=%@",[self getColumnText:selectStatement columnIndex:0]]];
            [self AppendLog:[NSString stringWithFormat:@"SValue=%@", [self getColumnText:selectStatement columnIndex:1]]];
        }
    }
    sqlite3_finalize(selectStatement);
}


@end
