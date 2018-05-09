//
//  Account.mm
//  
//
//  Created by boxytt on 2018/4/12.
//

#import "Account+WCTTableCoding.h"
#import "Account.h"
#import "Book.h"

#define ACCOUNT_TABLE @"account"

@implementation Account

WCDB_IMPLEMENTATION(Account)

WCDB_SYNTHESIZE(Account, accountID)
WCDB_SYNTHESIZE(Account, accountName)
WCDB_SYNTHESIZE(Account, iconName)
WCDB_SYNTHESIZE(Account, money)
WCDB_SYNTHESIZE(Account, isDebt)
WCDB_SYNTHESIZE(Account, bookName)

WCDB_PRIMARY(Account, accountID)
WCDB_INDEX(Account, "_index", accountID)

- (instancetype)initWithAccountID:(NSInteger)accountID
                      accountName:(NSString *)accountName
                         iconName:(NSString *)iconName
                            money:(NSNumber *)money
                           isDebt:(BOOL)isDebt
                         bookName:(NSString *)bookName {
    if (self = [super init]) {
        self.accountID = accountID;
        self.accountName = accountName;
        self.iconName = iconName;
        self.money = money;
        self.isDebt = isDebt;
        self.bookName = bookName;
    }
    return self;
}
  
@end



@interface AccountManager() {
    WCTDatabase * database;
}

@end


@implementation AccountManager

+ (instancetype)shareInstance {
    static AccountManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AccountManager alloc]init];
    });
    return instance;
}

#pragma mark - create
- (BOOL)creatDataBase {

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"myMoney.sqlite"];

    NSLog(@"path = %@", filePath);

    database = [[WCTDatabase alloc] initWithPath:filePath];

    if (![database isTableExists:ACCOUNT_TABLE]) {
        BOOL result = [database createTableAndIndexesOfName:ACCOUNT_TABLE withClass:Account.class];
        
        NSString *currentBookName = [BookManager shareInstance].currentBookName;
        Account *cashAccount = [[Account alloc] initWithAccountID:0 accountName:@"现金" iconName:@"现金" money:@0.00 isDebt:NO bookName:currentBookName];
        Account *zfbAccount = [[Account alloc] initWithAccountID:1 accountName:@"支付宝" iconName:@"支付宝" money:@0.00 isDebt:NO bookName:currentBookName];
        Account *wechatAccount = [[Account alloc] initWithAccountID:2 accountName:@"微信" iconName:@"微信" money:@0.00 isDebt:NO bookName:currentBookName];
        [self insertAccountWithAccount:cashAccount];
        [self insertAccountWithAccount:zfbAccount];
        [self insertAccountWithAccount:wechatAccount];
        
        return result;
    }
    return YES;
}

#pragma mark - insert
- (BOOL)insertAccountWithAccount:(Account *)account {
    if (!database) {
        [self creatDataBase];
    }
    return  [database insertObject:account into:ACCOUNT_TABLE];
}

#pragma mark - delete
- (BOOL)deleteAccountWithAccount:(Account *)account {
    if (!database) {
        [self creatDataBase];
    }
    return [database deleteObjectsFromTable:ACCOUNT_TABLE where:Account.accountName == account.accountName];
}

#pragma mark - update
- (BOOL)updateAccountWithAccount:(Account *)account {
    if (!database) {
        [self creatDataBase];
    }
    return [database updateRowsInTable:ACCOUNT_TABLE onProperties:{Account.accountName, Account.iconName, Account.money} withObject:account where:{Account.accountID == account.accountID, Account.bookName == [[BookManager shareInstance] currentBookName]}];
}


#pragma mark - select
- (NSArray *)selectAllAccount {
    if (!database) {
        [self creatDataBase];
    }
    NSArray<Account *> *accounts = [database getObjectsOfClass:Account.class fromTable:ACCOUNT_TABLE where:Account.bookName == [[BookManager shareInstance] currentBookName] orderBy:Account.accountID.order()];

    return accounts;
}

- (Account *)selectAccountWithAccountName:(NSString *)accountName {
    if (!database) {
        [self creatDataBase];
    }
    return [database getObjectsOfClass:Account.class fromTable:ACCOUNT_TABLE where:{Account.accountName == accountName, Account.bookName == [[BookManager shareInstance] currentBookName]}][0];
}

- (NSString *)selectIconNameWithAccountName:(NSString *)accountName {
    if (!database) {
        [self creatDataBase];
    }
    
    Account *account = [database getObjectsOfClass:Account.class fromTable:ACCOUNT_TABLE where:{Account.accountName == accountName, Account.bookName == [[BookManager shareInstance] currentBookName]}][0];
    return account.iconName ?: @"";
}


@end

