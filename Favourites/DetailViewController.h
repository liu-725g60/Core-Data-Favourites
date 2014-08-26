//
//  DetailViewController.h
//  Favourites
//
//  Created by Alek Åström on 2012-02-12.
//  Edited by Cenny Davidsson 2014-01-15.
//  Copyright (c) 2012 Linköpings Universitet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Link.h"
#import "NewLinkTableViewController.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Link *link;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
