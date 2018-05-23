//
//  Book+WCTTableCoding.h
//  MyMoney
//
//  Created by boxytt on 2018/4/25.
//  Copyright © 2018年 boxytt. All rights reserved.
//

#import "Book.h"
#import <WCDB/WCDB.h>

@interface Book (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(bookID)
WCDB_PROPERTY(bookName)
WCDB_PROPERTY(billCount)

@end
