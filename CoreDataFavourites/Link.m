//
//  Link.m
//  CoreDataFavourites
//
//  Created by Alek Åström on 2012-03-05.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Linköpings Universitet. All rights reserved.
//

// Detta är modellklassen för applikationen. Något som bör observeras är att klassen inte längre ärver av NSObject, utan NSManagedObject, vilket betyder att detta är en klass som representerar ett Core Data-objekt.

// Endast strängen för URLen och inte URLen själv sparas utan istället skapas ett NSURL-objekt dynamiskt som en getter till en readonly-property. Detta är eftersom Core Data saknar stöd för att lagra NSURL-objekt (utan modifikationer).

#import "Link.h"

@implementation Link

@dynamic title;
@dynamic urlString;

- (NSURL *)url {
    NSString *escapedString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:escapedString];
}


@end
