//
//  BinaryTree.h
//  BinaryTrees-WBB
//
//  Created by Apple on 2023/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchBinaryTree : NSObject

- (void)add:(id)element;

- (id)rootNode;
- (id)left:(id)node;
- (id)right:(id)node;
- (id)string:(id)node;

@end

NS_ASSUME_NONNULL_END
