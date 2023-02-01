//
//  BinaryTree.m
//  BinaryTrees-WBB
//
//  Created by Apple on 2023/1/30.
//

#import "SearchBinaryTree.h"

@interface BinaryNode : NSObject

@property (nonatomic, strong) BinaryNode *leftNode;
@property (nonatomic, strong) BinaryNode *rightNode;
@property (nonatomic, strong) BinaryNode *element;

@end

@implementation BinaryNode

+ (instancetype)initWithElement:(id)element
{
    return [[self alloc] initWithElement:element];
}

- (instancetype)initWithElement:(id)element
{
    self = [super init];
    if(self){
        self.element = element;
    }
    return self;
}

@end


@interface SearchBinaryTree()

@property (nonatomic, strong) BinaryNode *root;

@end


@implementation SearchBinaryTree

- (id)rootNode
{
    return self.root;
}

- (id)left:(id)node
{
    BinaryNode *obj = node;
    return obj.leftNode;
}

- (id)right:(id)node
{
    BinaryNode *obj = node;
    return obj.rightNode;
}

- (id)string:(id)node
{
    BinaryNode *obj = node;
    return obj.element;
}

- (void)add:(id)element
{
    if(!element) return;
    if(!self.root){
        self.root = [BinaryNode initWithElement:element];
        return;
    }
    
    BinaryNode *node = self.root;
    BinaryNode *parent = self.root;

    NSInteger cmp = 0;
    while (node) {
        parent = node;
        cmp = [self compareElement1:element element2:node.element];
        if(cmp > 0){
            node = node.rightNode;
        }else if(cmp < 0){
            node = node.leftNode;
        }else{
            return;
        }
    }
    
    BinaryNode *newNode = [BinaryNode initWithElement:element];
    if (cmp > 0) {
        parent.rightNode = newNode;
    }else if(cmp < 0){
        parent.leftNode = newNode;
    }
}

- (NSInteger)compareElement1:(id)element1 element2:(id)element2
{
    return [element1 compare:element2];
}


@end
