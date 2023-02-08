//
//  BTPrinter.m
//  Algorithm-OC
//
//  Created by Apple on 2023/2/1.
//

#import "BTPrinter.h"
#import "SearchBinaryTree.h"

@interface BTPrintNode : NSObject

@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) NSString *string;
@property (nonatomic, strong) BTPrintNode *left;
@property (nonatomic, strong) BTPrintNode *right;
@property (nonatomic, strong) BTPrintNode *parent;
@property (nonatomic, strong) id btNode;

@end


@implementation BTPrintNode

+ (instancetype)nodeWithNode:(id)node tree:(SearchBinaryTree *)tree
{
    BTPrintNode *pNode = [[BTPrintNode alloc] initWithString:[[tree string:node] description]];
    pNode.btNode = node;
    return pNode;
}


+ (instancetype)nodeWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if(self){
        self.width = (int)string.length;
        self.string = string;
    }
    return self;
}


- (int)leftNodeCenterX
{
    if(!self.left) return self.x;
    return self.left.x;
}

- (int)rightNodeCenterX
{
    if(!self.right) return self.x + self.width;
    return self.right.x;
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
//    [self addLineNodes];
    [self _print__001];
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

        for (NSInteger j=0; j<rows.count; j++) {
            BTPrintNode *pNode = rows[j];
            NSString *element = pNode.string;
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
                leftPNode.parent = printNode;
                self.maxWidth = MAX(leftPNode.width, self.maxWidth);
                printNode.left = leftPNode;
                [curRows addObject:leftPNode];
            }
            
            id rightNode = [self.tree right:printNode.btNode];
            if(rightNode){
                isStop = NO;
                BTPrintNode *rightPNode = [BTPrintNode nodeWithNode:rightNode tree:self.tree];
                rightPNode.parent = printNode;
                printNode.right = rightPNode;
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

- (void)addLineNodes
{
    NSMutableArray *newNodes = [@[] mutableCopy];
    for (NSInteger i=0; i<self.nodes.count; i++) {
        NSArray *rows = self.nodes[i];
        NSMutableArray *newRows = [@[] mutableCopy];
        NSMutableArray *verticalLines = [@[] mutableCopy];

        for (NSInteger j=0; j<rows.count; j++) {
            BTPrintNode *pNode = rows[j];
            NSArray *subRowNodes = [self lineNodesRelyOnNode:pNode];
            [newRows addObjectsFromArray:subRowNodes];
            [verticalLines addObjectsFromArray:[self verticallineNodesRelyOnNode:pNode]];
        }
        [newNodes addObject:newRows];
        [newNodes addObject:verticalLines];
    }
    self.nodes = [newNodes copy];
}

- (NSArray *)verticallineNodesRelyOnNode:(BTPrintNode *)node
{
    NSMutableArray *mutableArray = [@[] mutableCopy];
    BTPrintNode *left = [BTPrintNode nodeWithString:@"|"];
    left.x = [node leftNodeCenterX];
    left.y = node.y + 1;
    [mutableArray addObject:left];


    BTPrintNode *right = [BTPrintNode nodeWithString:@"|"];
    right.x = [node rightNodeCenterX];
    right.y = node.y + 1;
    [mutableArray addObject:right];
    return [mutableArray copy];
}


- (NSArray *)lineNodesRelyOnNode:(BTPrintNode *)node
{
//    [node.string isEqualToString:@"4"]
    NSMutableArray *mutableArray = [@[] mutableCopy];
    int leftWith = node.x - [node leftNodeCenterX];
    for (int i=0; i<leftWith; i++) {
        BTPrintNode *lineNode = [BTPrintNode nodeWithString:@"-"];
        lineNode.x = (int)[node leftNodeCenterX] + i;
        lineNode.y = node.y;
        [mutableArray addObject:lineNode];
    }

    [mutableArray addObject:node];

    int rightWith = [node rightNodeCenterX] - node.x - node.width;
    for (int i=0; i<rightWith; i++) {
        BTPrintNode *lineNode = [BTPrintNode nodeWithString:@"-"];
        lineNode.x = (int)[node rightNodeCenterX] + i;
        lineNode.y = node.y + 1;
        [mutableArray addObject:lineNode];
    }

    return [mutableArray copy];

}

@end
