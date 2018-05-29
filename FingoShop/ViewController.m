//
//  ViewController.m
//  Kart
//
//  Created by SkoopView on 13/06/16.
//  Copyright © 2016 SkoopView. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DealCell.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UIBarButtonItem+Badge.h"
#import "Cart.h"
#import "SVProgressHUD.h"
#import "bannerCollectionViewCell.h"
#import "TopBarNavigationVC.h"
#import "UIViewController+HeaderContainer.h"
#import "ProductDetailVC.h"
#import "ProductDetailNewVC.h"
#import "FingoShopTags.pch"

@interface ViewController ()<KIImagePagerDelegate, KIImagePagerDataSource,UICollectionViewDelegateFlowLayout>
{
    NSArray *pageImages,*offerzone_Array,*New_Arraivals_Array,*BrandStore_Array,*horizontal_imageArray;
    NSMutableArray *pageViews,*bannerarry,*banner_idarry,*women_bannerArray,*men_bannerArray;
    NSMutableArray *homePageCategoriesArr;
    NSMutableDictionary*pagenewImages;
    NSMutableArray *categoriesArr,*myarr;
    UIBarButtonItem *AP_barbutton2,*AP_barbutton3,*AP_barbutton4;
    NSMutableDictionary *childCategoriesDict,*newdict,*jsonDict;
    NSString *ServiceType;
    NSInteger bannerPageNum;
    NSMutableDictionary*datadic;
    NSMutableDictionary *homePageCategoriesDict;
    IBOutlet KIImagePager *_imagePager;
    IBOutlet KIImagePager *_womenImagePager;
    IBOutlet KIImagePager *_menImagePager;
    NSDictionary *selectedProduct;
    
   
}

@property (weak, nonatomic) IBOutlet UIImageView *top_banner_imageView;
@property (weak, nonatomic) IBOutlet UIImageView *middle_banner_imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView,*banner_Scroll,*banner_Scroll1,*offerZone_Scroll,*Arrival_Scroll,*brandStore_Scroll;

@property (weak, nonatomic) IBOutlet UIPageControl *bannerPageControl,*offerPagecontroller,*newarraivalpagecontroller,*brandstorePagecontroller;
@property (weak, nonatomic) IBOutlet UICollectionView *delaoftheday_collecVW,*Electronics_collecVW,*Womens_collecVW,*Mens_collecVW,*Art_collecVW,*kids_collecVW,*home_kichen_collecVW,*sports_collecVW,*books_collecVW;
//@property (strong, nonatomic) IBOutlet UICollectionView *Horizontal_CollectionVW;

@property(nonatomic,strong) NSMutableArray *Dealoftheday_Arr,*Electronics_Arr,*Womens_Arr,*Mens_arr,*baby_kids_Arr,*top_bannerArray,*banner_topArray,*women_ObjectArray,*men_ObjectArray;


@property (weak, nonatomic) IBOutlet UIButton *btnViewAll1;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAll2;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAll3;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAll4;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAll5;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAll6;

- (IBAction)btnViewAllClicked1:(id)sender;
- (IBAction)btnViewAllClicked2:(id)sender;
- (IBAction)btnViewAllClicked3:(id)sender;
- (IBAction)btnViewAllClicked4:(id)sender;
- (IBAction)btnViewAllClicked5:(id)sender;
- (IBAction)btnMenuClicked:(id)sender;



@end

@implementation ViewController
AppDelegate *apdl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_WSConstScreenValue isEqualToString:@"SlideMenu"]) {
        
        [self performSegueWithIdentifier:@"detailSegue" sender:self];
        
    }
    
    // TopBar Navigation
    TopBarNavigationVC *topVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TopBarNavigationVC"];
    [self displayContentController:topVC];
    [topVC.menu_button setHidden :NO];
    [topVC.back_button setHidden :YES];
    
    // Configure layout
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(self.view.frame.size.width - 10, 150)];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.Mens_collecVW setCollectionViewLayout:layout];
    [self.Art_collecVW setCollectionViewLayout:layout];
     [self.Art_collecVW setScrollEnabled:NO];
     [self.Mens_collecVW setScrollEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification) name:@"logoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification) name:@"loginNotification" object:nil];
    
    apdl=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
   // [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack]; // Progress
    [APPDELEGATE showCustomLoader:self];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(queue, ^{
        
        [self callHomepageCategoriesService];
        
      
       // self.banner_topArray = [homePageCategoriesDict objectForKey:@"banner_top"];
      //  self.banner_middleArray = [homePageCategoriesDict objectForKey:@"banner_middle"];
       /* NSDictionary *category_dict = [_banner_topArray objectAtIndex:0];
        NSString *urlString =[NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
        urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:urlString];
        [self.top_banner_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];
        NSDictionary *category_dict1 = [_banner_middleArray objectAtIndex:0];
        NSString *urlString1 =[NSString stringWithFormat:@"%@",[category_dict1 objectForKey:@"source_file"]];
        urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url1 = [NSURL URLWithString:urlString1];
        [self.middle_banner_imageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"place"]];
        */
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.top_bannerArray =[homePageCategoriesDict objectForKey:@"topbanners"];
            bannerarry = [[NSMutableArray alloc]init];
            for (int i = 0; i<_top_bannerArray.count; i++)
            {
                NSDictionary *category_dict = [_top_bannerArray objectAtIndex:i];
                NSString *urlString =[NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
                urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
                [bannerarry addObject:urlString];
                
                
            }
            [_imagePager reloadData];
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.women_ObjectArray =[homePageCategoriesDict objectForKey:@"womenfashion_banner"];
            women_bannerArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<_women_ObjectArray.count; i++)
            {
                NSDictionary *category_dict = [_women_ObjectArray objectAtIndex:i];
                NSString *urlString =[NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
                urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
                [women_bannerArray addObject:urlString];
                
            }
             [_womenImagePager reloadData];
       });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.men_ObjectArray =[homePageCategoriesDict objectForKey:@"menfashion_banner"];
            men_bannerArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<_men_ObjectArray.count; i++)
            {
                NSDictionary *category_dict = [_men_ObjectArray objectAtIndex:i];
                NSString *urlString =[NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
                urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                
                [men_bannerArray addObject:urlString];
                
            }
            [_menImagePager reloadData];
        });
        
      
        self.Dealoftheday_Arr = [homePageCategoriesDict objectForKey:@"dealoftheday_banner"];
        self.Womens_Arr=[homePageCategoriesDict objectForKey:@"womenaccessories_banner"];
        self.Mens_arr=[homePageCategoriesDict objectForKey:@"menaccesories_banner"];
        self.Electronics_Arr = [homePageCategoriesDict objectForKey:@"electronics_banner"];
        self.baby_kids_Arr=[homePageCategoriesDict objectForKey:@"kidfashion_banner"];
        
       dispatch_sync(dispatch_get_main_queue(), ^{
            // Set progress indicator to complete?
            [_delaoftheday_collecVW reloadData];
            [_Womens_collecVW reloadData];
            [_Mens_collecVW reloadData];
            [_Electronics_collecVW reloadData];
            [_kids_collecVW reloadData];

           // [SVProgressHUD [APPDELEGATE showCustomLoader:self];];
           [APPDELEGATE removeCustomLoader:self];
       });
        
    });
    

    
    
//    NSInteger offerzone_pageCount  = offerzone_Array.count;
//    NSInteger newArraial_pageCount = New_Arraivals_Array.count;
//    NSInteger brandstore_pageCount = BrandStore_Array.count;
    
    
    // Set up the offer page control
    
//    self.offerPagecontroller.currentPage = 0;
//    self.offerPagecontroller.numberOfPages = offerzone_pageCount;
//    
//       // Set up the offer page control
//    
//    self.brandstorePagecontroller.currentPage = 0;
//    self.brandstorePagecontroller.numberOfPages = brandstore_pageCount;
    
  
    
//    _banner_Scroll1.clipsToBounds = YES;
//    _banner_Scroll1.pagingEnabled = YES;
//    _banner_Scroll1.showsHorizontalScrollIndicator = NO;
//    _banner_Scroll1.showsVerticalScrollIndicator = NO;
//    _banner_Scroll1.scrollsToTop = NO;
    
    
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    [_imagePager.pageControl setHidden:YES];
    _imagePager.slideshowTimeInterval = 5.5f;
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    _womenImagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _womenImagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    [_womenImagePager.pageControl setHidden:YES];
    _womenImagePager.slideshowTimeInterval = 5.5f;
    _womenImagePager.slideshowShouldCallScrollToDelegate = YES;
    _menImagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _menImagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    [_menImagePager.pageControl setHidden:YES];
    _menImagePager.slideshowTimeInterval = 5.5f;
    _menImagePager.slideshowShouldCallScrollToDelegate = YES;
}

- (void)scrollimagehandleOneTap:(UITapGestureRecognizer *)tapGesture
{
    _WSConstScreenValue = @"Home";
    //    [self selectMainCategoryId:@"OFFERS ZONE"];
    
    _WSConstSelectedCategoryID = [[pageImages objectAtIndex:bannerPageNum] objectForKey:@"banner_id"];
   // [self performSegueWithIdentifier:@"detailSegue" sender:self];
    
}


-(void)logoutNotification {
    [self CheckCart];
    
}
-(void)loginNotification {
    [self CheckCart];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    self.mainScrollView.contentSize=CGSizeMake(self.mainScrollView.bounds.size.width, 2100);
    
  /*  CGSize pagesScrollViewSize = self.banner_Scroll.frame.size;
    CGSize pagesScrollViewSize1 = self.banner_Scroll1.frame.size;
    CGSize pagesScrollViewSize2 = self.offerZone_Scroll.frame.size;
    CGSize pagesScrollViewSize3 = self.Arrival_Scroll.frame.size;
    CGSize pagesScrollViewSize4 = self.brandStore_Scroll.frame.size;
    
    self.banner_Scroll.contentSize = CGSizeMake(pagesScrollViewSize.width * pageImages.count, pagesScrollViewSize.height);
    
    self.banner_Scroll1.contentSize = CGSizeMake(pagesScrollViewSize1.width * pageImages.count, pagesScrollViewSize1.height);
   */
    
//    self.offerZone_Scroll.contentSize = CGSizeMake(pagesScrollViewSize2.width * offerzone_Array.count, pagesScrollViewSize2.height);
//    
//    self.Arrival_Scroll.contentSize = CGSizeMake(pagesScrollViewSize3.width * New_Arraivals_Array.count, pagesScrollViewSize3.height);
//    
//    self.brandStore_Scroll.contentSize = CGSizeMake(pagesScrollViewSize4.width * BrandStore_Array.count, pagesScrollViewSize4.height);
//    
//    
//    //        [self loadVisiblePages];
//    [self loadVisible_offerZonePages];
//    [self loadVisible_NewArraivalsPages];
//    [self loadVisible_BrandStorePages];
    
    [self CheckCart];
//    NSURL*url=[NSURL URLWithString:@"https://www.fingoshop.com/restconnect/index/getHomePageBanners?SID=p5i1vm8klt4asns7b3us9fm671"];
//    NSData*jsondata=[NSData dataWithContentsOfURL:url];
//    NSError*err;
//    datadic=[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&err];
//    NSLog(@" the dic sat   %@",datadic);
//    bannerarry=[datadic valueForKey:@"source_file"];
    
    
    
}
//-(void)mybanners {
//    NSURL*url=[NSURL URLWithString:@"https://www.fingoshop.com/restconnect/index/getHomePageBanners?SID=p5i1vm8klt4asns7b3us9fm671"];
//    NSData*jsondata=[NSData dataWithContentsOfURL:url];
//    NSError*err;
//    datadic=[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&err];
//    NSLog(@" the dic sat   %@",datadic);
//   // NSError*error;
//    
//
//         bannerarry=[datadic valueForKey:@"source_file"];
//
//   
//        
//  //  }
//    
//    if(apdl.net == 0){
//        NSLog(@"nothing to do");
//    }
//    else{
//        NSURL*url=[NSURL URLWithString:@"https://www.fingoshop.com/restconnect/index/getHomePageBanners?SID=p5i1vm8klt4asns7b3us9fm671"];
//        NSData*jsondata=[NSData dataWithContentsOfURL:url];
//        NSError*err;
//        datadic=[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:&err];
//        NSLog(@" the dic sat   %@",datadic);
//        // NSError*error;
//        
//        
//        bannerarry=[datadic valueForKey:@"source_file"];
//
//        
//    }
//
//}
//
- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.banner_Scroll.frame.size.width;
    
    NSInteger page = (NSInteger)floor((self.banner_Scroll.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    
    // Update the page control
    self.bannerPageControl.currentPage = page;
     bannerPageNum = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.banner_Scroll.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        UIImageView *newPageView = [[UIImageView alloc] init];
        
        NSString *urlString =[NSString stringWithFormat:@"%@",[[pageImages objectAtIndex:page] objectForKey:@"source_file"]];
        
        //urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"prof img is %@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        [newPageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];
        
        
        newPageView.contentMode = UIViewContentModeScaleToFill;
        newPageView.frame = frame;
        [self.banner_Scroll addSubview:newPageView];
        
        [pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}
- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


//- (void)loadVisible_offerZonePages {
//    // First, determine which page is currently visible
//    CGFloat pageWidth = self.offerZone_Scroll.frame.size.width;
//    
//    NSInteger page = (NSInteger)floor((self.offerZone_Scroll.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
//    
//    
//    // Update the page control
//    self.offerPagecontroller.currentPage = page;
//    
//    // Work out which pages we want to load
//    NSInteger firstPage = page - 1;
//    NSInteger lastPage = page + 1;
//    
//    // Purge anything before the first page
//    for (NSInteger i=0; i<firstPage; i++) {
//        [self purge_offerPage:i];
//    }
//    for (NSInteger i=firstPage; i<=lastPage; i++) {
//        [self load_offerPage:i];
//    }
//    for (NSInteger i=lastPage+1; i<offerzone_Array.count; i++) {
//        [self purge_offerPage:i];
//    }
//}

//- (void)load_offerPage:(NSInteger)page {
//    if (page < 0 || page >= offerzone_Array.count) {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }
//    
//    // Load an individual page, first seeing if we've already loaded it
//    UIView *pageView = [Offerzone_views objectAtIndex:page];
//    if ((NSNull*)pageView == [NSNull null]) {
//        CGRect frame = self.offerZone_Scroll.bounds;
//        frame.origin.x = frame.size.width * page;
//        frame.origin.y = 0.0f;
//        
//        UIImageView *newPageView= [[UIImageView alloc] initWithImage:[offerzone_Array objectAtIndex:page]];
//        newPageView.contentMode = UIViewContentModeScaleToFill;
//        newPageView.frame = frame;
//        [self.offerZone_Scroll addSubview:newPageView];
//        
//        [Offerzone_views replaceObjectAtIndex:page withObject:newPageView];
//    }
//}
//
//- (void)purge_offerPage:(NSInteger)page {
//    if (page < 0 || page >= offerzone_Array.count) {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }
//    
//    // Remove a page from the scroll view and reset the container array
//    UIView *pageView = [Offerzone_views objectAtIndex:page];
//    if ((NSNull*)pageView != [NSNull null]) {
//        [pageView removeFromSuperview];
//        [Offerzone_views replaceObjectAtIndex:page withObject:[NSNull null]];
//    }
//}

//- (void)loadVisible_NewArraivalsPages
//{
//    // First, determine which page is currently visible
//    CGFloat pageWidth = self.Arrival_Scroll.frame.size.width;
//    
//    NSInteger page = (NSInteger)floor((self.Arrival_Scroll.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
//    
//    
//    // Update the page control
//    self.newarraivalpagecontroller.currentPage = page;
//    
//    // Work out which pages we want to load
//    NSInteger firstPage = page - 1;
//    NSInteger lastPage = page + 1;
//    
//    // Purge anything before the first page
//    for (NSInteger i=0; i<firstPage; i++) {
//        [self purge_NewArraivalsPage:i];
//    }
//    for (NSInteger i=firstPage; i<=lastPage; i++) {
//        [self load_NewArraivalsPage:i];
//    }
//    for (NSInteger i=lastPage+1; i<New_Arraivals_Array.count; i++) {
//        [self purge_NewArraivalsPage:i];
//    }
//    
//    
//}
//
//- (void)load_NewArraivalsPage:(NSInteger)page
//{
//    if (page < 0 || page >= New_Arraivals_Array.count)
//    {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }
//    
//    // Load an individual page, first seeing if we've already loaded it
//    UIView *pageView = [newArra_views objectAtIndex:page];
//    if ((NSNull*)pageView == [NSNull null]) {
//        CGRect frame = self.Arrival_Scroll.bounds;
//        frame.origin.x = frame.size.width * page;
//        frame.origin.y = 0.0f;
//        
//        UIImageView *newPageView3 = [[UIImageView alloc] initWithImage:[New_Arraivals_Array objectAtIndex:page]];
//        newPageView3.contentMode = UIViewContentModeScaleToFill;
//        newPageView3.frame = frame;
//        [self.Arrival_Scroll addSubview:newPageView3];
//        
//        
//        [newArra_views replaceObjectAtIndex:page withObject:newPageView3];
//    }
//}
//
//- (void)purge_NewArraivalsPage:(NSInteger)page {
//    if (page < 0 || page >= New_Arraivals_Array.count) {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }
//    
//    // Remove a page from the scroll view and reset the container array
//    UIView *pageView = [newArra_views objectAtIndex:page];
//    if ((NSNull*)pageView != [NSNull null]) {
//        [pageView removeFromSuperview];
//        [newArra_views replaceObjectAtIndex:page withObject:[NSNull null]];
//    }
//}
//

//- (void)loadVisible_BrandStorePages {
//    // First, determine which page is currently visible
//    CGFloat pageWidth = self.brandStore_Scroll.frame.size.width;
//    
//    NSInteger page = (NSInteger)floor((self.brandStore_Scroll.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
//    
//    
//    // Update the page control
//    self.brandstorePagecontroller.currentPage = page;
//    
//    // Work out which pages we want to load
//    NSInteger firstPage = page - 1;
//    NSInteger lastPage = page + 1;
//    
//    // Purge anything before the first page
//    for (NSInteger i=0; i<firstPage; i++) {
//        [self purge_BrandStorePage:i];
//    }
//    for (NSInteger i=firstPage; i<=lastPage; i++) {
//        [self load_BrandStorePage:i];
//    }
//    for (NSInteger i=lastPage+1; i<BrandStore_Array.count; i++) {
//        [self purge_BrandStorePage:i];
//    }
//}

//- (void)load_BrandStorePage:(NSInteger)page {
//    if (page < 0 || page >= BrandStore_Array.count) {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }

    // Load an individual page, first seeing if we've already loaded it
  //  UIView *pageView = [brandstore_views objectAtIndex:page];
    //if ((NSNull*)pageView == [NSNull null]) {
    //    CGRect frame = self.brandStore_Scroll.bounds;
    //    frame.origin.x = frame.size.width * page;
      //  frame.origin.y = 0.0f;
    //
        //UIImageView *newPageView4 = [[UIImageView alloc] initWithImage:[BrandStore_Array objectAtIndex:page]];
        //newPageView4.contentMode = UIViewContentModeScaleToFill;
        //newPageView4.frame = frame;
        //[self.brandStore_Scroll addSubview:newPageView4];
        
        
       // [brandstore_views replaceObjectAtIndex:page withObject:newPageView4];
   // }
//}

//- (void)purge_BrandStorePage:(NSInteger)page {
//    if (page < 0 || page >= BrandStore_Array.count) {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }
//    
//    // Remove a page from the scroll view and reset the container array
//    UIView *pageView = [brandstore_views objectAtIndex:page];
//    if ((NSNull*)pageView != [NSNull null]) {
//        [pageView removeFromSuperview];
//        [brandstore_views replaceObjectAtIndex:page withObject:[NSNull null]];
//    }
//}

#pragma mark - KIImagePager DataSource
//#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    if (pager == _imagePager){
         return bannerarry;
    }else if (pager == _womenImagePager){
         return women_bannerArray;
    }else if (pager == _menImagePager){
        return men_bannerArray;
    }else{
         return bannerarry;
    }

}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleToFill;
}

//- (NSString *) captionForImageAtIndex:(NSUInteger)index inPager:(KIImagePager *)pager
//{
//    return @[
//             @"First screenshot",
//             @"Another screenshot",
//             @"Last one! ;-)"
//             ][index];
//}

#pragma mark - KIImagePager Delegate
- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
{
    //  NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index
{
    NSString *selectedItemID;
    NSDictionary *category_dict;
    if (imagePager == _imagePager){
        category_dict = [_top_bannerArray objectAtIndex:index];
        selectedItemID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
      
    }else if (imagePager == _womenImagePager){
        category_dict = [_women_ObjectArray objectAtIndex:index];
        selectedItemID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
    }else if (imagePager == _menImagePager){
        category_dict = [_men_ObjectArray objectAtIndex:index];
        selectedItemID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
    }
    _WSConstScreenValue = @"Home";
    _WSConstSelectedCategoryID = selectedItemID;
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
    
}

#pragma mark - button Actions

- (IBAction)tollFreeButtonAction:(id)sender
{
    NSString *URLString = [@"tel://" stringByAppendingString:@"18003139899"];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    [[UIApplication sharedApplication] openURL:URL];
}



#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // Load the pages which are now on screen
//    [self loadVisiblePages];
//    [self loadVisible_offerZonePages];
//    [self loadVisible_NewArraivalsPages];
//    [self loadVisible_BrandStorePages];
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//     if (collectionView==_Electronics_collecVW)
//    {
//        return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetHeight(collectionView.frame)));
//    }
//     else{
//         
//         return  CGSizeMake(0, 0);
//     }
//    
//}

#pragma mark - UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  if (collectionView==_delaoftheday_collecVW)
    {
        return _Dealoftheday_Arr.count;
    }else if (collectionView==_Womens_collecVW)
    {
        return _Womens_Arr.count;
    } else if (collectionView==_Mens_collecVW)
    {
        return _Mens_arr.count;
    }
    else if (collectionView==_Electronics_collecVW)
    {
        return _Electronics_Arr.count;
    }
    else if (collectionView==_kids_collecVW)
    {
        return _baby_kids_Arr.count;
    }else{
        return 0;}

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    /*if (collectionView==_delaoftheday_collecVW)
    {
        return CGSizeMake(self.view.frame.size.width / 2 - 20, 111) ;
    }else if (collectionView==_Womens_collecVW)
    {
        return CGSizeMake(self.view.frame.size.width / 2 - 20, 111) ;
    }
    else if (collectionView==_Mens_collecVW)
    {
        return CGSizeMake(self.view.frame.size.width / 2 - 20, 111) ;
    }else{
     */
        return CGSizeMake(self.view.frame.size.width / 2 - 20, 111) ;
   // }
    
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (collectionView==_delaoftheday_collecVW)
    {
        DealCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"dealCell" forIndexPath:indexPath];
        
        
        if (cell==nil)
        {
            cell=[[DealCell alloc]initWithFrame:CGRectZero];
        }
       
        NSDictionary *category_dict = [_Dealoftheday_Arr objectAtIndex:indexPath.row];
        NSString *urlString = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
         urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:urlString];
         [cell.imageVW sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];
        cell.layer.borderWidth = 0.3;
        cell.layer.borderColor = [[UIColor clearColor]CGColor];
        return cell;
    }  else if (collectionView==_Womens_collecVW)
    {
        DealCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"dealCell" forIndexPath:indexPath];
        
        
        if (cell==nil)
        {
            cell=[[DealCell alloc]initWithFrame:CGRectZero];
        }
        
        NSDictionary *category_dict = [_Womens_Arr objectAtIndex:indexPath.row];
        NSString *urlString = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
        urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:urlString];
        [cell.imageVW sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];
        cell.layer.borderWidth = 0.3;
        cell.layer.borderColor = [[UIColor clearColor]CGColor];
        return cell;
    } else if (collectionView==_Mens_collecVW)
    {
        DealCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"dealCell" forIndexPath:indexPath];
        
        
        if (cell==nil)
        {
            cell=[[DealCell alloc]initWithFrame:CGRectZero];
        }
        
        NSDictionary *category_dict = [_Mens_arr objectAtIndex:indexPath.row];
        NSString *urlString = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
        urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:urlString];
        [cell.imageVW sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];
        cell.layer.borderWidth = 0.3;
        cell.layer.borderColor = [[UIColor clearColor]CGColor];
        return cell;
    }
    else if (collectionView==_Electronics_collecVW)
    {
        DealCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"dealCell" forIndexPath:indexPath];
        
        
        if (cell==nil)
        {
            cell=[[DealCell alloc]initWithFrame:CGRectZero];
        }
        
        NSDictionary *category_dict = [_Electronics_Arr objectAtIndex:indexPath.row];
        NSString *urlString = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
        urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:urlString];
        [cell.imageVW sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];
        cell.layer.borderWidth = 0.3;
        cell.layer.borderColor = [[UIColor clearColor]CGColor];
        return cell;
    }else if (collectionView==_kids_collecVW)
    {
        DealCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"dealCell" forIndexPath:indexPath];
        
        
        if (cell==nil)
        {
            cell=[[DealCell alloc]initWithFrame:CGRectZero];
        }
        
        NSDictionary *category_dict = [_baby_kids_Arr objectAtIndex:indexPath.row];
        NSString *urlString = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
        urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *url = [NSURL URLWithString:urlString];
        [cell.imageVW sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];
        cell.layer.borderWidth = 0.3;
        cell.layer.borderColor = [[UIColor clearColor]CGColor];
        return cell;
    }else{
        UITableViewCell * cell = [[UITableViewCell alloc]init];
        return cell;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*  NSDictionary *category_dict = [_Dealoftheday_Arr objectAtIndex:indexPath.row];
     selectedProduct = category_dict;
     selectedItemID =[NSString stringWithFormat:@"%@",[category_dict objectForKey:@"banner_id"]];
     /*  selectedItemType = @"Electronics";
     NSLog(@"%@",selectedItemID); _WSConstScreenValue = @"Home";
     _WSConstSelectedCategoryID = selectedItemID;
     _WSConstSelectedCategoryType = selectedItemType;
     [self performSegueWithIdentifier:@"detailSegue" sender:self];
     
     
     // [self callProductDetailsService:selectedItemID];
     */
    NSDictionary *category_dict;

       if (collectionView==_delaoftheday_collecVW)
    {
       category_dict = [_Dealoftheday_Arr objectAtIndex:indexPath.row];
        selectedProduct = category_dict;
        _WSConstScreenValue = @"Home";
        _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
        [self performSegueWithIdentifier:@"detailSegue" sender:self];
        
    }
    else if (collectionView==_Womens_collecVW)
    {
       category_dict = [_Womens_Arr objectAtIndex:indexPath.row];
        selectedProduct = category_dict;
        _WSConstScreenValue = @"Home";
        _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
        [self performSegueWithIdentifier:@"detailSegue" sender:self];
    }
    else if (collectionView==_Mens_collecVW)
    {
        category_dict = [_Mens_arr objectAtIndex:indexPath.row];
        selectedProduct = category_dict;
        _WSConstScreenValue = @"Home";
        _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
        [self performSegueWithIdentifier:@"detailSegue" sender:self];
        
    }
    else if (collectionView==_Electronics_collecVW)
    {
       category_dict = [_Electronics_Arr objectAtIndex:indexPath.row];
        selectedProduct = category_dict;
        _WSConstScreenValue = @"Home";
        _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
        [self performSegueWithIdentifier:@"detailSegue" sender:self];
    }else if (collectionView==_Electronics_collecVW)
    {
        
       category_dict = [_Electronics_Arr objectAtIndex:indexPath.row];
        selectedProduct = category_dict;
        _WSConstScreenValue = @"Home";
        _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
        [self performSegueWithIdentifier:@"detailSegue" sender:self];
    }
    

}

#pragma mark - Button Action Methods

- (IBAction)btnMenuClicked:(id)sender
{
    ECSlidingViewController *slidingViewController = self.slidingViewController;
    if (slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        [slidingViewController resetTopViewAnimated:YES];
        [self.view setUserInteractionEnabled:YES];
    } else {
        [slidingViewController anchorTopViewToRightAnimated:YES];
        [self.view setUserInteractionEnabled:NO];
    }
    
}
- (IBAction)btnViewAllClicked1:(id)sender {
    
    NSDictionary *category_dict = [_Mens_arr objectAtIndex:0];
    selectedProduct = category_dict;
    _WSConstScreenValue = @"Home";
    _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category"]];
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
 
    
}

- (IBAction)btnViewAllClicked2:(id)sender {
    
//    [self selectMainCategoryId:@"Women"];
//    _WSConstSelectedCategoryType = @"Womens";
//    _WSConstScreenValue = @"Home";
    NSDictionary *category_dict = [_Womens_Arr objectAtIndex:0];
    selectedProduct = category_dict;
    _WSConstScreenValue = @"Home";
    _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category"]];
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
    
}

- (IBAction)btnViewAllClicked3:(id)sender {
//    [self selectMainCategoryId:@"Men"];
//    _WSConstSelectedCategoryType = @"Mens";
//    _WSConstScreenValue = @"Home";
    NSDictionary *category_dict = [_Electronics_Arr objectAtIndex:0];
    selectedProduct = category_dict;
    _WSConstScreenValue = @"Home";
    _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category"]];
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

- (IBAction)btnViewAllClicked4:(id)sender {
   // [self selectMainCategoryId:@"Arts & Crafts"];
  //  _WSConstScreenValue = @"Home";
  //  NSDictionary *category_dict = [_Art_Arr objectAtIndex:0];
//    //selectedProduct = category_dict;
//    _WSConstScreenValue = @"Home";
//    _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category"]];
//    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

- (IBAction)btnViewAllClicked5:(id)sender {
//  //  NSDictionary *category_dict = [_home_kichen_Arr objectAtIndex:0];
//    selectedProduct = category_dict;
//    _WSConstScreenValue = @"Home";
//    _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category"]];
//    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}


-(void)selectMainCategoryId:(NSString *)name {
    
    for (NSDictionary *dict in categoriesArr) {
        if ([[dict objectForKey:@"MainCategory"] isEqualToString:name]) {
            _WSConstSelectedCategoryID = [dict objectForKey:@"MainCategoryId"];
            NSLog(@"%@",_WSConstSelectedCategoryID);
            [self performSegueWithIdentifier:@"detailSegue" sender:self];
            return;
        }
    }
    
}


/*- (void)btnUserClicked:(id)sender
{
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"email"] && ![[[NSUserDefaults standardUserDefaults] stringForKey:@"email"] isEqualToString:@""]) {
        
        [self.tabBarController setSelectedIndex:3];
    }
    else
    {
        
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
        
    }
}
*/


-(void)btnVirtualShopping:(id)sender
{
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VirtualShoppingVC"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)btnSearchClicked:(id)sender
{
    
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnCartClicked:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"email"] && ![[[NSUserDefaults standardUserDefaults] stringForKey:@"email"] isEqualToString:@""]) {
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"CartCount"] integerValue] > 0) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Cart"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else {
            UIAlertController*  alertController = [UIAlertController alertControllerWithTitle:@"FINGOSHOP" message:@"Add atleast one Product to your cart" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }
    else {
        UIAlertController*  alertController = [UIAlertController alertControllerWithTitle:@"FINGOSHOP" message:@"Please login to get cart information" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

-(BOOL)checkCartIsEmpty
{
    
    Cart *cart = [Cart singleInstance];
    
    if (cart.positions.count>0) {
        return YES;
        
    }
    
    
    return NO;
}
- (IBAction)topbannerbuttonClicked:(id)sender {

    NSDictionary *category_dict = [_banner_topArray objectAtIndex:0];
    selectedProduct = category_dict;
    _WSConstScreenValue = @"Home";
    _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}
//- (IBAction)middlebannerbuttonClicked:(id)sender {
//    NSDictionary *category_dict = [_banner_middleArray objectAtIndex:0];
//    selectedProduct = category_dict;
//    _WSConstScreenValue = @"Home";
//    _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
//    [self performSegueWithIdentifier:@"detailSegue" sender:self];
//}

//-(void)menproductSelectedButtonAction:(UIButton *)sender
//{
//    NSDictionary *category_dict = [_Electronics_Arr objectAtIndex:sender.tag];
//    selectedProduct = category_dict;
//     NSString *selectedItemID =[NSString stringWithFormat:@"%@",[category_dict objectForKey:@"entity_id"]];
//    [self callProductDetailsService:selectedItemID];
//    
//}

#pragma mark - ServiceConnection Methods


-(void)callMainBannerImagesService {
    //[SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack]; // Progress
    [APPDELEGATE showCustomLoader:self];
    serviceconn = [[ServiceConnection alloc]init];
    serviceconn.delegate = self;
    ServiceType = @"MainBannerImages";
    [serviceconn GetMainBannerImages];
    
}

-(void)callHomepageCategoriesService
{
    
    if(apdl.net == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:apdl.alertTTL message:apdl.alertMSG delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        
        return;
    }

    NSString *url_str1= @"https://www.fingoshop.com/restconnect/apihomepage/home1";
    //NSString *url_str = [url_str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url=[NSURL URLWithString:url_str1];
    
    NSData *data=[NSData dataWithContentsOfURL:url];
    
    NSError *error;
    if (data) {
        NSMutableDictionary *Dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        homePageCategoriesDict = Dic;
        
      //  categoriesArr=[[NSMutableArray alloc] init];
        
      //  childCategoriesDict=[[NSMutableDictionary alloc] init];
    
     /*   for (int i=0; i<homePageCategoriesArr.count; i++) {
            
            NSMutableDictionary *childDict=[[NSMutableDictionary alloc] init];
            
            NSString *str=[[homePageCategoriesArr objectAtIndex:i] objectForKey:@"name"];
            
            
            [childCategoriesDict setObject:[[homePageCategoriesArr objectAtIndex:i] objectForKey:@"children"] forKey:str];
            
            [childDict setObject:[[homePageCategoriesArr objectAtIndex:i] objectForKey:@"name"] forKey:@"MainCategory"];
            [childDict setObject:[[homePageCategoriesArr objectAtIndex:i] objectForKey:@"id"] forKey:@"MainCategoryId"];
            
            [categoriesArr addObject:childDict];
            
            
        }
      */

    }
       NSLog(@"%@",homePageCategoriesDict);
}


-(void)callMainMenuService
{
   // [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack]; // Progress
    [APPDELEGATE showCustomLoader:self];
    serviceconn = [[ServiceConnection alloc]init];
    serviceconn.delegate = self;
    [serviceconn GetMainMenu];
}

-(void)callProductDetailsService :(NSString *)ProductId
{
    
    if(apdl.net == 0)
    {
        UIAlertController*  alertController = [UIAlertController alertControllerWithTitle:apdl.alertTTL message:apdl.alertMSG preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
   // [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack]; // Progress
    [APPDELEGATE showCustomLoader:self];
    
    serviceconn = [[ServiceConnection alloc]init];
    serviceconn.delegate = self;
    ServiceType=@"Details";
    [serviceconn GetProductDetails:ProductId];
    
}



#pragma mark - ServiceConnection Delegate Methods

- (void)jsonData:(NSMutableDictionary*)jsonDict
{
    if ([ServiceType isEqualToString:@"MainBannerImages"] )
    {
       // NSLog(@"Banner Images: %@",jsonDict);
        
 /*   pagenewImages = [jsonDict valueForKey:@"source_file"];
       // myarr = [myarr addObject:pageImages];
        //myarr = [NSMutableArray new];
//        [newdict addEntriesFromDictionary:pageImages];
//        NSLog(@"newdict is %@",newdict);
//        myarr = [NSMutableArray arrayWithObject:pageImages];
        NSLog(@"pageimages is %@",pagenewImages);
        
      //  [pageimg addObject:pageImages];
     //   NSLog(@"page images :%@",pageImages);
        NSInteger banner_pageCount = pageImages.count;
        // Set up the page control
        self.bannerPageControl.currentPage = 0;
        self.bannerPageControl.numberOfPages = banner_pageCount;
        
        // Set up the array to hold the views for each page
        pageViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < banner_pageCount; ++i) {
            [pageViews addObject:[NSNull null]];
        }
        
        CGSize pagesScrollViewSize = self.banner_Scroll.frame.size;
        
        self.banner_Scroll.contentSize = CGSizeMake(pagesScrollViewSize.width * pageImages.count, pagesScrollViewSize.height);
        
        [self loadVisiblePages];
        */
        }
    
    else if ([ServiceType isEqualToString:@"Details"]) {
        
        NSDictionary *productDict = [jsonDict objectForKey:@"product"];
        
        _selectedProductDict = [productDict mutableCopy];
        
        
        NSArray *attributeArr = (NSArray *)[_selectedProductDict objectForKey:@"configurable_attributes"];
        
        /*    if ([attributeArr count] == 0 || [attributeArr count] == 2) {
         [self performSegueWithIdentifier:@"ProductDetail" sender:self];
         }else{
         
         [self performSegueWithIdentifier:@"ProductDetail1" sender:self];
         }
         */
        
        if ([attributeArr count]>0) {
           // [self performSegueWithIdentifier:@"ProductDetail1" sender:self];
            
            ProductDetailNewVC *productDetailsNewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailNewVC"];
            productDetailsNewVC.productDetailsDict = [selectedProduct mutableCopy];
            productDetailsNewVC.productDetailsDict1 = [_selectedProductDict mutableCopy];
            [self.navigationController pushViewController:productDetailsNewVC animated:YES];
            
        }
        else {
        
            ProductDetailVC *productDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetail"];
            productDetailsVC.productDetailsDict = [selectedProduct mutableCopy];
            
            productDetailsVC.productDetailsDict1 = [_selectedProductDict mutableCopy];
            [self.navigationController pushViewController:productDetailsVC animated:YES];
        }
        
        
    }
    
    
    
    
    
   // [SVProgressHUD [APPDELEGATE showCustomLoader:self];];
    [APPDELEGATE removeCustomLoader:self];
}


- (void)errorMessage:(NSString *)errMsg
{
//    [SVProgressHUD [APPDELEGATE showCustomLoader:self];];
    [APPDELEGATE removeCustomLoader:self];
}

-(void)CheckCart
{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"email"] && ![[[NSUserDefaults standardUserDefaults] stringForKey:@"email"] isEqualToString:@""]) {
        AP_barbutton2.badgeValue =[[NSUserDefaults standardUserDefaults] stringForKey:@"CartCount"];
        
    }
    else {
        AP_barbutton2.badgeValue = 0;
    }
    
}

-(void)callGetCartInfoService
{
   // [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack]; // Progress
    [APPDELEGATE showCustomLoader:self];
    
    serviceconn = [[ServiceConnection alloc]init];
    serviceconn.delegate = self;
    ServiceType=@"GetCartInfo";
    [serviceconn GetCartInfo];
}

@end