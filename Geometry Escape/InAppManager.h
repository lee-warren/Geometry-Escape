//
//  InAppManager.h
//  Don't Touch The Green Balls
//
//  Created by Lee Warren on 25/08/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "InAppObserver.h"

@interface InAppManager : NSObject <SKProductsRequestDelegate> {
    
    
    
}



+(InAppManager*) sharedManager;


-(void) buyFeature1; //declared this so that any class can call this and initiate Product 1

-(void) buyFeature2; //declared this so that any class can call this and initiate Product 2
-(void) buyFeature3; //declared this so that any class can call this and initiate Product 3
-(void) buyFeature4; //declared this so that any class can call this and initiate Product 4


-(bool) isFeature1PurchasedAlready; //declared so any class could check if product 1 was purchased prior to doing something

-(void) restoreCompletedTransactions; //if you sell non-consumable purchases you must give people the option to RESTORE


-(void) failedTransaction:(SKPaymentTransaction*) transaction;
-(void) provideContent:(NSString*)productIdentifier;


@end
