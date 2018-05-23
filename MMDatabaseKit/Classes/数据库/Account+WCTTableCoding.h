//
//  Account+WCTTableCoding.h
//  
//
//  Created by boxytt on 2018/4/12.
//

#import "Account.h"
#import <WCDB/WCDB.h>

@interface Account (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(accountID)
WCDB_PROPERTY(accountName)
WCDB_PROPERTY(money)
WCDB_PROPERTY(iconName)
WCDB_PROPERTY(isDebt)
WCDB_PROPERTY(bookName)

@end
