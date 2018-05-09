//
//  Bill.mm
//  MyMoney
//
//  Created by boxytt on 2018/4/18.
//  Copyright © 2018年 boxytt. All rights reserved.
//

#import "Bill+WCTTableCoding.h"
#import "Bill.h"
#import "Book.h"
#define Bill_TABLE @"bill"

@implementation Bill

WCDB_IMPLEMENTATION(Bill)
WCDB_SYNTHESIZE(Bill, billID)
WCDB_SYNTHESIZE(Bill, createTime)
WCDB_SYNTHESIZE(Bill, amount)
WCDB_SYNTHESIZE(Bill, accountName)
WCDB_SYNTHESIZE(Bill, type)
WCDB_SYNTHESIZE(Bill, remark)
WCDB_SYNTHESIZE(Bill, bookName)
WCDB_SYNTHESIZE(Bill, year)
WCDB_SYNTHESIZE(Bill, month)
WCDB_SYNTHESIZE(Bill, day)
WCDB_SYNTHESIZE(Bill, weekday)
WCDB_SYNTHESIZE(Bill, weekOfYear)


WCDB_PRIMARY(Bill, billID)
WCDB_INDEX(Bill, "_index", billID)

- (instancetype)initWithBillID:(NSInteger)billID
                          createTime:(NSDate *)createTime
                        amount:(NSNumber *)amount
                   accountName:(NSString *)accountName
                          type:(NSString *)type
                        remark:(NSString *)remark
                      bookName:(NSString *)bookName {
    if (self = [super init]) {
        self.billID = billID;
        self.createTime = createTime;
        self.amount = amount;
        self.accountName = accountName;
        self.type = type;
        self.remark = remark;
        self.bookName = bookName;
        
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear) fromDate:createTime];
        self.year = [comps year];
        self.month = [comps month];
        self.day = [comps day];
        self.weekday = [comps weekday];
        self.weekOfYear = [comps weekOfYear];
    }
    return self;
}
  
@end

#pragma mark - BillManager

@interface BillManager() {
    WCTDatabase * database;
}

@end

@implementation BillManager

+ (instancetype)shareInstance {
    static BillManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BillManager alloc] init];
    });
    return instance;
}

#pragma mark - create
- (BOOL)creatDataBase {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"myMoney.sqlite"];
    
    NSLog(@"path = %@", filePath);
    
    database = [[WCTDatabase alloc] initWithPath:filePath];
    
    if (![database isTableExists:Bill_TABLE]) {
        BOOL result = [database createTableAndIndexesOfName:Bill_TABLE withClass:Bill.class];
        return result;
    }
    return YES;
}

#pragma mark - insert
- (BOOL)insertBillWithBill:(Bill *)bill {
    if (!database) {
        [self creatDataBase];
    }
    
    BookManager *bookManager = [BookManager shareInstance];
    Book *currentBook = [bookManager selectCurrentBook];
    currentBook.billCount++;
    [bookManager updateBookWithBook:currentBook];
    
    return  [database insertObject:bill into:Bill_TABLE];
}

#pragma mark - delete
- (BOOL)deleteBillWithBill:(Bill *)bill {
    if (!database) {
        [self creatDataBase];
    }
    return [database deleteObjectsFromTable:Bill_TABLE where:Bill.billID > 0];
    
}

#pragma mark - update
- (BOOL)updateBillWithBill:(Bill *)bill {
    if (!database) {
        [self creatDataBase];
    }
    return [database updateRowsInTable:Bill_TABLE onProperties:Bill.amount withObject:bill where:{Bill.billID == bill.billID && Bill.bookName == [[BookManager shareInstance] currentBookName]}];
    
    
}


#pragma mark - select
- (NSArray *)selectAllBill {
    if (!database) {
        [self creatDataBase];
    }
    NSArray<Bill *> *bills = [database getObjectsOfClass:Bill.class fromTable:Bill_TABLE where:Bill.bookName == [[BookManager shareInstance] currentBookName] orderBy:Bill.billID.order(WCTOrderedDescending)];
    return bills;
}

- (NSArray *)selectBillsWithYear:(NSInteger)year {
    if (!database) {
        [self creatDataBase];
    }
    NSArray<Bill *> *bills = [database getObjectsOfClass:Bill.class fromTable:Bill_TABLE where:{Bill.year == year && Bill.bookName == [[BookManager shareInstance] currentBookName]} orderBy:Bill.billID.order(WCTOrderedDescending)];
    return bills;
}

- (NSArray *)selectBillsWithYear:(NSInteger)year month:(NSInteger)month {
    if (!database) {
        [self creatDataBase];
    }
    NSArray<Bill *> *bills = [database getObjectsOfClass:Bill.class fromTable:Bill_TABLE where:{Bill.year == year && Bill.month == month && Bill.bookName == [[BookManager shareInstance] currentBookName]} orderBy:Bill.billID.order(WCTOrderedDescending)];
    return bills;
}

- (NSArray *)selectBillsWithYear:(NSInteger)year weekOfYear:(NSInteger)weekOfYear {
    if (!database) {
        [self creatDataBase];
    }
    NSArray<Bill *> *bills = [database getObjectsOfClass:Bill.class fromTable:Bill_TABLE where:{Bill.year == year && Bill.weekOfYear == weekOfYear && Bill.bookName == [[BookManager shareInstance] currentBookName]} orderBy:Bill.billID.order(WCTOrderedDescending)];
    return bills;
}

- (NSArray *)selectBillsWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    if (!database) {
        [self creatDataBase];
    }
    NSArray<Bill *> *bills = [database getObjectsOfClass:Bill.class fromTable:Bill_TABLE where:{Bill.year == year && Bill.month == month && Bill.day == day && Bill.bookName == [[BookManager shareInstance] currentBookName]} orderBy:Bill.billID.order(WCTOrderedDescending)];
    return bills;
}


- (NSArray *)selectBillsWithAccount:(Account *)account {
    if (!database) {
        [self creatDataBase];
    }
    NSArray<Bill *> *bills = [database getObjectsOfClass:Bill.class fromTable:Bill_TABLE where:{Bill.accountName == account.accountName && Bill.bookName == [[BookManager shareInstance] currentBookName]} orderBy:Bill.billID.order(WCTOrderedDescending)];
    return bills;
}


@end


