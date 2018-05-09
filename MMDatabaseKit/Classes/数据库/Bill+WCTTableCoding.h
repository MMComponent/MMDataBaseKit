//
//  Bill+WCTTableCoding.h
//  MyMoney
//
//  Created by boxytt on 2018/4/18.
//  Copyright © 2018年 boxytt. All rights reserved.
//

#import "Bill.h"
#import <WCDB/WCDB.h>

@interface Bill (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(billID)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(amount)
WCDB_PROPERTY(accountName)
WCDB_PROPERTY(type)
WCDB_PROPERTY(remark)
WCDB_PROPERTY(bookName)
WCDB_PROPERTY(year)
WCDB_PROPERTY(month)
WCDB_PROPERTY(day)
WCDB_PROPERTY(weekday)
WCDB_PROPERTY(weekOfYear)

@end
