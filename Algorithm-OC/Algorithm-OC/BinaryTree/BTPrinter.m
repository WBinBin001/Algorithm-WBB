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

+ (instancetype)nodeWithNode:(id)node tree:(SearchBinaryTree *)tree
{
    return [[BTPrintNode alloc] initWithNode:node tree:tree];
}

- (instancetype)initWithNode:(id)node tree:(SearchBinaryTree *)tree
{
    self = [super init];
    if(self){
        self.btNode = node;
        self.width = [[tree string:node] description].length;
    }
    return self;
}

@end



@interface BTPrinter()

@property (nonatomic, strong) BTPrintNode *root;
@property (nonatomic, strong) SearchBinaryTree *tree;
@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, assign) NSUInteger maxWidth;

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
    self.root = [BTPrintNode nodeWithNode:[tree rootNode] tree:tree];
    self.tree = tree;
    self.nodes = [@[] mutableCopy];
    self.maxWidth = [[self.tree string:[tree rootNode]] description].length;
}

- (void)print
{
    [self addNodes];
    [self configNodeOriginPoint];
//    [self _print__001];
    [self _print__002];
}

/*
 38
 18-69
 4-34-85
 29-36-71-100
 */
- (void)_print__001
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

/*
 ------------38-------------
 ----18--------------69-----
 -4---------34--------85----
 29------36------71------100
 */
- (void)_print__002
{
    NSString *normalString = @"";
    NSArray *lastRows = self.nodes.lastObject;
    NSUInteger space = self.maxWidth + 2;
    NSUInteger lastRowLength = (lastRows.count - 1) * space + lastRows.count * self.maxWidth;
        for (NSInteger i=0; i<lastRowLength; i++) {
        normalString = [normalString stringByAppendingString:@"-"];
    }
    
    NSString *newline = @"\n";
    NSString *string = newline;

    for (NSInteger i = 0; i < self.nodes.count; i++) {

        NSArray *rows = self.nodes[i];
        NSMutableString *currentLineString = [normalString mutableCopy];

        for (NSInteger i=0; i<rows.count; i++) {
            BTPrintNode *pNode = rows[i];
            NSString *element = [[self.tree string:pNode.btNode] description];
            [currentLineString replaceCharactersInRange:NSMakeRange(pNode.x, element.length) withString:element];
        }
        string = [string stringByAppendingString:currentLineString];
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
                BTPrintNode *leftPNode = [BTPrintNode nodeWithNode:leftNode tree:self.tree];
                self.maxWidth = MAX(leftPNode.width, self.maxWidth);
                [curRows addObject:leftPNode];
            }
            
            id rightNode = [self.tree right:printNode.btNode];
            if(rightNode){
                isStop = NO;
                BTPrintNode *rightPNode = [BTPrintNode nodeWithNode:rightNode tree:self.tree];
                self.maxWidth = MAX(rightPNode.width, self.maxWidth);
                [curRows addObject:rightPNode];
            }
        }
        
        if(isStop) return;
        
        [self.nodes addObject:curRows];
        preRows = curRows;
    }
}


- (void)configNodeOriginPoint
{
    NSArray *lastRows = self.nodes.lastObject;
    NSUInteger space = self.maxWidth + 2;
    NSUInteger lastRowLength = (lastRows.count - 1) * space + lastRows.count * self.maxWidth;
    
    for (NSInteger i=0; i<self.nodes.count; i++) {
        NSArray *rows = self.nodes[i];
        
        NSUInteger tmpSpace = (lastRowLength - (rows.count - 1) * space) / rows.count;
        NSUInteger nodeMargins = (tmpSpace - self.maxWidth) >> 1;
        NSUInteger x = 0;

        for (NSInteger j = 0; j<rows.count; j++) {
            BTPrintNode *pNode = rows[j];

            x = x + nodeMargins;

            if(j){
                x = x + space;
            }
            
            pNode.x = x;
            pNode.y = i;
            x = x + self.maxWidth;
            x = x + nodeMargins;
            
            NSLog(@"pNode = %@",[self.tree string:pNode.btNode]);
            NSLog(@"pNode.x = %ld",pNode.x);
            NSLog(@"pNode.y = %ld",pNode.y);
            NSLog(@"");
        }
        
    }
}

@end
