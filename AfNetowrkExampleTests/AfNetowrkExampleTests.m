//
//  AfNetowrkExampleTests.m
//  AfNetowrkExampleTests
//
//  Created by Zumry Gapstars on 7/2/17.
//  Copyright © 2017 Appsgit. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AfNetowrkExampleTests : XCTestCase

@end

@implementation AfNetowrkExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testLogics {
    

    NSString *name = @"this is tets";
    
    XCTAssertNotNil(name, @"areaXYResult.dataSet is null.");
    
}


@end
