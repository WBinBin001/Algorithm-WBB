//
//  BTPrinter.h
//  Algorithm-OC
//
//  Created by Apple on 2023/2/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SearchBinaryTree;

@interface BTPrinter : NSObject

+ (instancetype)initWithTree:(SearchBinaryTree *)tree;

- (void)print;

@end

NS_ASSUME_NONNULL_END
