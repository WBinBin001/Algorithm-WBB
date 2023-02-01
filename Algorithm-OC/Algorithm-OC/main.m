//
//  main.m
//  Algorithm-OC
//
//  Created by Apple on 2023/1/30.
//

#import <Foundation/Foundation.h>
#import "SearchBinaryTree.h"
#import "BTPrinter.h"

void test_01(void)
{
    NSArray *arr = @[@38,@18,@4,@69,@85,@71,@34,@36,@29,@100];
//    int data[] = { 38, 18, 4, 69, 85, 71, 34, 36, 29, 100 };
    SearchBinaryTree *tree = [SearchBinaryTree new];
    for (NSNumber *num in arr) {
        [tree add:num];
    }
    
    [[BTPrinter initWithTree:tree] print];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        test_01();
        NSLog(@"Hello, World!");
    }
    return 0;
}
