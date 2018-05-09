//
//  Book.mm
//  MyMoney
//
//  Created by boxytt on 2018/4/25.
//  Copyright © 2018年 boxytt. All rights reserved.
//

#import "Book+WCTTableCoding.h"
#import "Book.h"

#define BOOK_TABLE @"book"

@implementation Book

WCDB_IMPLEMENTATION(Book)
WCDB_SYNTHESIZE(Book, bookID)
WCDB_SYNTHESIZE(Book, bookName)
WCDB_SYNTHESIZE(Book, billCount)

WCDB_PRIMARY(Book, bookID)
WCDB_INDEX(Book, "_index", bookID)

- (instancetype)initWithBookID:(NSInteger)bookID bookName:(NSString *)bookName billCount:(NSInteger)billCount {
    if (self = [super init]) {
        self.bookID = bookID;
        self.bookName = bookName;
        self.billCount = billCount;
    }
    return self;
}

@end


@interface BookManager () {
    WCTDatabase * database;
}

@end

@implementation BookManager

+ (instancetype)shareInstance {
    static BookManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BookManager alloc] init];
    });
    return instance;
}

#pragma mark - create
- (BOOL)creatDataBase {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"myMoney.sqlite"];
    
    NSLog(@"path = %@", filePath);
    
    database = [[WCTDatabase alloc] initWithPath:filePath];
    
    if (![database isTableExists:BOOK_TABLE]) {
        BOOL result = [database createTableAndIndexesOfName:BOOK_TABLE withClass:Book.class];
        
        Book *book = [[Book alloc] initWithBookID:0 bookName:@"默认账本" billCount:0];
        [self insertBookWithBook:book];
        [[NSUserDefaults standardUserDefaults] setObject:@"默认账本" forKey:@"currentBookName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return result;
    }
    return YES;
}

#pragma mark - insert
- (BOOL)insertBookWithBook:(Book *)book {
    if (!database) {
        [self creatDataBase];
    }
    return  [database insertObject:book into:BOOK_TABLE];
}

#pragma mark - delete
- (BOOL)deleteBookWithBook:(Book *)book {
    if (!database) {
        [self creatDataBase];
    }
    return [database deleteObjectsFromTable:BOOK_TABLE where:Book.bookID > 0];
    
}

#pragma mark - update
- (BOOL)updateBookWithBook:(Book *)book {
    if (!database) {
        [self creatDataBase];
    }
    return [database updateAllRowsInTable:BOOK_TABLE onProperty:Book.billCount withObject:book];
    
}


#pragma mark - select
- (NSArray *)selectAllBook {
    if (!database) {
        [self creatDataBase];
    }
    NSArray<Book *> *books = [database getObjectsOfClass:Book.class fromTable:BOOK_TABLE orderBy:Book.bookID.order()];
    
    return books;
}

- (Book *)selectCurrentBook {
    if (!database) {
        [self creatDataBase];
    }
    Book *book = [database getObjectsOfClass:Book.class fromTable:BOOK_TABLE where:Book.bookName == [self currentBookName]][0];
    
    return book;
}

- (NSString *)currentBookName {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"currentBookName"] ?: @"";
}

#pragma mark - 切换账本
- (void)switchBookWithBookName:(NSString *)bookName {
    [[NSUserDefaults standardUserDefaults] setObject:bookName forKey:@"currentBookName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
