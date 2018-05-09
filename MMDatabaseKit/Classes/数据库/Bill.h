//
//  Bill.h
//  MyMoney
//
//  Created by boxytt on 2018/4/18.
//  Copyright © 2018年 boxytt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface Bill : NSObject

@property (nonatomic, assign) NSInteger billID;
@property (nonatomic, assign) NSNumber *amount;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger weekday;
@property (nonatomic, assign) NSInteger weekOfYear;

- (instancetype)initWithBillID:(NSInteger)billID
                          createTime:(NSDate *)createTime
                        amount:(NSNumber *)amount
                   accountName:(NSString *)accountName
                          type:(NSString *)type
                        remark:(NSString *)remark
                      bookName:(NSString *)bookName;

@end


@interface BillManager : NSObject

+ (instancetype)shareInstance;

- (BOOL)creatDataBase;

- (BOOL)insertBillWithBill:(Bill *)bill;

- (BOOL)deleteBillWithBill:(Bill *)bill;

- (BOOL)updateBillWithBill:(Bill *)bill;

- (NSArray *)selectAllBill;

- (NSArray *)selectBillsWithYear:(NSInteger)year;

- (NSArray *)selectBillsWithYear:(NSInteger)year month:(NSInteger)month;

- (NSArray *)selectBillsWithYear:(NSInteger)year weekOfYear:(NSInteger)weekOfYear;

- (NSArray *)selectBillsWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

- (NSArray *)selectBillsWithAccount:(Account *)account;

@end
