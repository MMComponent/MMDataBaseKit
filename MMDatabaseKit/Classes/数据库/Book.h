//
//  Book.h
//  MyMoney
//
//  Created by boxytt on 2018/4/25.
//  Copyright © 2018年 boxytt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property(nonatomic, assign) NSInteger bookID;
@property(nonatomic, strong) NSString *bookName;
@property(nonatomic, assign) NSInteger billCount;

- (instancetype)initWithBookID:(NSInteger)bookID bookName:(NSString *)bookName billCount:(NSInteger)billCount;

@end

@interface BookManager : NSObject


+ (instancetype)shareInstance;

- (BOOL)creatDataBase;

- (BOOL)insertBookWithBook:(Book *)book;

- (BOOL)deleteBookWithBook:(Book *)book;

- (BOOL)updateBookWithBook:(Book *)book;

- (NSArray *)selectAllBook;

- (Book *)selectCurrentBook;

- (NSString *)currentBookName;


@end
