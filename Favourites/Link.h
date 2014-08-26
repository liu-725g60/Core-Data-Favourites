//
//  Link.h
//  CoreDataFavourites
//
//  Created by Alek Åström on 2012-03-05.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Linköpings Universitet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Link : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * urlString;
@property (nonatomic, readonly) NSURL *url;

@end
