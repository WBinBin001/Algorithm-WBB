//
//  BTPrinter.m
//  Algorithm-OC
//
//  Created by Apple on 2023/2/1.
//

#import "BTPrinter.h"
#import "SearchBinaryTree.h"

@interface BTPrintNode : NSObject

@property (nonatomic, assign) NSUInteger x;
@property (nonatomic, assign) NSUInteger y;
@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, strong) BTPrintNode *left;
@property (nonatomic, strong) BTPrintNode *right;
@property (nonatomic, strong) id btNode;

@end


@implementation BTPrintNode

+ (instancetype)initWithNode:(id)node
{
    return [[BTPrintNode alloc] initWithNode:node];
}

- (instancetype)initWithNode:(id)node
{
    self = [super init];
    if(self){
        self.btNode = node;
    }
    return self;
}

@end



@interface BTPrinter()

@property (nonatomic, strong) BTPrintNode *root;
@property (nonatomic, strong) SearchBinaryTree *tree;
@property (nonatomic, strong) NSMutableArray *nodes;

@end


@implementation BTPrinter


+ (instancetype)initWithTree:(SearchBinaryTree *)tree
{
    return [[BTPrinter alloc] initWithTree:tree];
}

- (instancetype)initWithTree:(SearchBinaryTree *)tree
{
    self = [super init];
    if(self){
        [self configWithTree:tree];
    }
    return self;
}

- (void)configWithTree:(SearchBinaryTree *)tree
{
    self.root = [BTPrintNode initWithNode:[tree rootNode]];
    self.tree = tree;
    self.nodes = [@[] mutableCopy];
}

- (void)print
{
    [self addNodes];
    [self _print];
}

- (void)_print
{
    NSLog(@"打印二叉树");

    NSString *hyphen = @"-";
    NSString *newline = @"\n";
    NSString *string = newline;

    for (NSInteger i = 0; i < self.nodes.count; i++) {

        NSArray *rows = self.nodes[i];
        for (NSInteger i=0; i<rows.count; i++) {
            BTPrintNode *pNode = rows[i];
            if(i){
                string = [string stringByAppendingString:hyphen];
            }
            NSString *element = [self.tree string:pNode.btNode];
            string = [string stringByAppendingString:[element description]];
        }
        string = [string stringByAppendingString:newline];
    }
    NSLog(@"%@",string);
}

- (void)addNodes
{
    
    NSMutableArray *preRows = [@[] mutableCopy];

    [preRows addObject:self.root];
    [self.nodes addObject:preRows];
    
    while (1) {
        NSMutableArray *curRows = [@[] mutableCopy];
        BOOL isStop = YES;
        for (BTPrintNode *printNode in preRows) {
            id leftNode = [self.tree left:printNode.btNode];
            if(leftNode){
                isStop = NO;
                BTPrintNode *leftPNode = [BTPrintNode initWithNode:leftNode];
                [curRows addObject:leftPNode];
            }
            
            id rightNode = [self.tree right:printNode.btNode];
            if(rightNode){
                isStop = NO;
                BTPrintNode *rightPNode = [BTPrintNode initWithNode:rightNode];
                [curRows addObject:rightPNode];
            }
        }
        
        if(isStop) return;
        
        [self.nodes addObject:curRows];
        preRows = curRows;
    }
}

@end
