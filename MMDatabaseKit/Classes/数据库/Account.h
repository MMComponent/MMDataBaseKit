//
//  Account.h
//  
//
//  Created by boxytt on 2018/4/12.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, assign) NSInteger accountID;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, assign) BOOL isDebt;
@property (nonatomic, strong) NSString *bookName;

- (instancetype)initWithAccountID:(NSInteger)accountID
                      accountName:(NSString *)accountName
                         iconName:(NSString *)iconName
                            money:(NSNumber *)money
                           isDebt:(BOOL)isDebt
                         bookName:(NSString *)bookName;
@end


@interface AccountManager : NSObject

+ (instancetype)shareInstance;

- (BOOL)creatDataBase;

- (BOOL)insertAccountWithAccount:(Account *)account;

- (BOOL)deleteAccountWithAccount:(Account *)account;

- (BOOL)updateAccountWithAccount:(Account *)account;

- (Account *)selectAccountWithAccountName:(NSString *)accountName;

- (NSArray *)selectAllAccount;

- (NSString *)selectIconNameWithAccountName:(NSString *)accountName;


@end





