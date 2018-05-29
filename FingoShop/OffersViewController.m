//
//  OffersViewController.m
//  FingoShop
//
//  Created by Rambabu Mannam on 25/04/1938 Saka.
//  Copyright © 1938 Saka fis. All rights reserved.
//

#import "OffersViewController.h"
#import "NotificationCell.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"
#import "UIBarButtonItem+Badge.h"
#import "UIViewController+HeaderContainer.h"
#import "TopBarNavigationVC.h"
#import "FingoShopTags.pch"
#import <QuartzCore/QuartzCore.h>
#import "ItemCell.h"
#import "DealCell.h"
#import "ProductDetailVC.h"
#import "ProductDetailNewVC.h"
#import "AppDelegate.h"

#define IS_IPHONE5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define IS_IPHONE6 ( [ [ UIScreen mainScreen ] bounds ].size.height == 667 )
#define IS_IPHONE6S ( [ [ UIScreen mainScreen ] bounds ].size.height == 736 )
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds ].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds ].size.height

@interface OffersViewController ()
{
    NSMutableArray *delasoffersArray;
    NSMutableArray *clearanceoffersArray;
    NSDictionary *selectedProduct;
    NSMutableDictionary *avaulable_filter_Dict;
    NSMutableArray *avaulable_filters_array;
    NSString *ServiceType;
    NSInteger indexVal;
}
@property (nonatomic,retain)NSArray *bannerarr;
@property (weak, nonatomic) IBOutlet UICollectionView *dealsoftheday_collecVW;
@property (weak, nonatomic) IBOutlet UICollectionView *clearanceofthesale_collecVW;
@property (weak, nonatomic) IBOutlet UIButton *clearance_button;
@property (weak, nonatomic) IBOutlet UIButton *dealoftheday_button;
@end

@implementation OffersViewController
AppDelegate *apdl_detail1;
- (void)viewDidLoad {
    [super viewDidLoad];
    apdl_detail1=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    delasoffersArray = [[NSMutableArray alloc] init];
    clearanceoffersArray = [[NSMutableArray alloc] init];
    
    // TopBar Navigation
    TopBarNavigationVC *topVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TopBarNavigationVC"];
    [self displayContentController:topVC];
    [topVC.menu_button setHidden :NO];
    [topVC.back_button setHidden :YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification) name:@"logoutNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotification) name:@"loginNotification" object:nil];
    
     ServiceType=@"Dealsoftheday";
     [self callGetDealsOffersList:@""];
     [self buttonColors];
    _clearance_button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.dealsoftheday_collecVW setHidden:NO];
    [self.clearanceofthesale_collecVW setHidden:YES];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    NSLog(@"====%f=====%f",SCREEN_WIDTH,SCREEN_HEIGHT);
    [layout setItemSize:CGSizeMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT - 114)/2)];
    [layout setSectionInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [layout setMinimumInteritemSpacing:0.0];
    [layout setMinimumLineSpacing:0.0];
    [self.clearanceofthesale_collecVW setCollectionViewLayout:layout];
    
    
}

-(void)viewWillAppear:(BOOL)animated
    {
        
        [self.navigationController setNavigationBarHidden:YES];
//        if ([_WSConstScreenValue isEqualToString:@"Search"]) {
//
//            _itemsListArr=[[NSMutableArray alloc]init];
//            [_itemsListArr addObjectsFromArray:_searchFiltersProductsArray];
//        }
//        else {
//
//            if ([_backNavigationSortOption isEqualToString:@"Sorted"]) {
//
//                _backNavigationSortOption = @"";
//
//            }
//            else{
//
//                [APPDELEGATE showCustomLoader:self];
//                // Dispatch a block of code to a background queue
//                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//                dispatch_async(queue, ^{
//                    // Do initialisation in the background
//                    /*dispatch_sync(dispatch_get_main_queue(), ^{
//                     // Set progress indicator to complete?
//                     [APPDELEGATE showCustomLoader:self];
//                     });
//
//                     */
//
//
//                    //  NSLog(@" call product list:%@",   )
//
//                    NSLog(@"selected category id:%@", _WSConstSelectedCategoryID);
//                    // Call back to the main queue if you want to update any UI when you are done
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [self callProductListService:_WSConstSelectedCategoryID];
//                        // Set progress indicator to complete?
//                        [_Detail_collecVW reloadData];
//                        //[SVProgressHUD [APPDELEGATE showCustomLoader:self];];
//                        [APPDELEGATE removeCustomLoader:self];
//                    });
//                });
//            }
//
//            [self CheckCart];
//        }
//
        
        
        
        
        
    }
//    -(void)callProductListService :(NSString *)CategoryId{
//
//        if(apdl_detail.net == 0)
//        {
//            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:apdl_detail.alertTTL message:apdl_detail.alertMSG preferredStyle:UIAlertControllerStyleAlert];
//
//            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            }]];
//
//            [self presentViewController:alertController animated:YES completion:nil];
//
//
//            return;
//        }
//
//
//        NSString *url_str1=[NSString stringWithFormat:@"https://www.fingoshop.com/restconnect/api/getCategoryProductsList?id=%@&sid=%@",CategoryId,[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"]];
//
//        NSString *url_str = [url_str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        NSURL *url=[NSURL URLWithString:url_str];
//
//        NSData *data=[NSData dataWithContentsOfURL:url];
//
//        NSError *error;
//        NSMutableDictionary *resultsDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//
//
//        avaulable_filter_Dict = resultsDict;
//
//        /* avaulable_filter_Dict =[resultsDict objectForKey:@"avaulable_filters"];
//         NSDictionary *filtersarr=[resultsDict valueForKeyPath:@"avaulable_filters.price"];
//
//         NSLog(@"=====%@====",[filtersarr valueForKey:@"label"]);
//
//         NSArray *optionsArray = [[resultsDict valueForKeyPath:@"avaulable_filters.vesbrand"] valueForKey:@"options"];
//
//         */
//
//        if ([resultsDict objectForKey:@"records"] == [NSNull null]) {
//
//            //[self.empty_wishlistView setHidden: NO];
//            //[self.view bringSubviewToFront:self.empty_wishlistView];
//
//        }
//        else{
//            NSMutableArray *productsarr=[resultsDict objectForKey:@"records"];
//            _itemsListArr=[[NSMutableArray alloc]init];
//            [_itemsListArr addObjectsFromArray:productsarr];
//
//        }
//    }
//#pragma mark - NSURLConnection Delegate Methods
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//    {
//        [receivedData setLength:0];
//        NSLog(@"%@",response);
//    }
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//    {
//        [receivedData appendData:data];
//        NSLog(@"getting data");
//    }
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//    {
//        // [SVProgressHUD [APPDELEGATE showCustomLoader:self];];
//        [APPDELEGATE removeCustomLoader:self];
//
//        NSError *error;
//        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingAllowFragments error:&error];
//        NSLog(@"%@",jsonDict);
//        if (error!=nil)
//        {
//            NSLog(@"JSON Parsing Error %@",[error localizedDescription]);
//        }
//        else {
//            if ([_availableFiltersDict count]>0) {
//                [_availableFiltersDict removeAllObjects];
//            }
//            _availableFiltersDict = [[jsonDict objectForKey:@"avaulable_filters"] mutableCopy];
//        }
//    }


    
-(void)loginNotification {
    [self CheckCart];
    
}

-(void)logoutNotification {
    [self CheckCart];
    
}
-(void)buttonColors{
    _dealoftheday_button.layer.borderWidth = 2;
    _dealoftheday_button.layer.borderColor = [UIColor blueColor].CGColor;
    _dealoftheday_button.layer.cornerRadius = 5;
     [_dealoftheday_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //_dealoftheday_button.clipsToBounds = YES;
    _dealoftheday_button.layer.masksToBounds = YES;
    _clearance_button.layer.borderWidth = 2;
    _clearance_button.layer.borderColor = [UIColor blueColor].CGColor;
    _clearance_button.layer.cornerRadius = 5;
   // _clearance_button.clipsToBounds = YES;
     _clearance_button.layer.masksToBounds = YES;
    [_clearance_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
}

-(void)CheckCart
{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"email"] && ![[[NSUserDefaults standardUserDefaults] stringForKey:@"email"] isEqualToString:@""]) {
        //AP_barbutton2.badgeValue =[[NSUserDefaults standardUserDefaults] stringForKey:@"CartCount"];

    }
    else {
        //AP_barbutton2.badgeValue = 0;
    }

}
- (IBAction)clearancesaleAction:(id)sender {
    [self callGetDealsOffersList:@"1039"];
    ServiceType=@"Clearanceoftheday";
     _dealoftheday_button.layer.borderColor = [UIColor lightGrayColor].CGColor;
     [_dealoftheday_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
     [_clearance_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     _clearance_button.layer.borderColor = [UIColor blueColor].CGColor;
}
- (IBAction)dealofthedayAction:(id)sender {
    [self callGetDealsOffersList:@""];
     ServiceType=@"Dealsoftheday";
    [_dealoftheday_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     _dealoftheday_button.layer.borderColor = [UIColor blueColor].CGColor;
    _clearance_button.layer.borderColor = [UIColor lightGrayColor].CGColor;
   [_clearance_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
}
    
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
            
            //[self performSegueWithIdentifier:@"loginSegue" sender:self];
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self.navigationController pushViewController:vc animated:YES];
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}
- (IBAction)tollFreeButtonAction:(id)sender
{
    NSString *URLString = [@"tel://" stringByAppendingString:@"18003139899"];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    [[UIApplication sharedApplication] openURL:URL];
}



/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [offersArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2; // you can have your own choice, of course
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1; // you can have your own choice, of course
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 150.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell"];
    if (cell == nil)
    {
        cell = [[NotificationCell alloc]initWithFrame:CGRectZero];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    
  
    NSString *urlString =[NSString stringWithFormat:@"%@",[[offersArray objectAtIndex:indexPath.section] objectForKey:@"main_image"]];
    
    urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"prof img is %@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [cell.notificationImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _WSConstSelectedCategoryID = [[offersArray objectAtIndex:indexPath.section] objectForKey:@"id"];
    _WSConstScreenValue = @"Offers";
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
 */
//#pragma mark - UICollectionView Delegate Methods
//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {

        if (collectionView == _dealsoftheday_collecVW) {
            return delasoffersArray.count;
            
        } else {
            return clearanceoffersArray.count;
        }
        
    }

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     if (collectionView ==_dealsoftheday_collecVW)
     {
     return CGSizeMake(self.view.frame.size.width / 2 - 20, 111) ;
     }else{
      return CGSizeMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT - 114)/2);
    }
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        
        if (collectionView ==_dealsoftheday_collecVW)
        {
            DealCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"dealCell" forIndexPath:indexPath];
            
            
            if (cell==nil)
            {
                cell=[[DealCell alloc]initWithFrame:CGRectZero];
            }
            
            NSDictionary *category_dict = [delasoffersArray objectAtIndex:indexPath.row];
            NSString *urlString = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"source_file"]];
            urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL *url = [NSURL URLWithString:urlString];
            [cell.imageVW sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];
            cell.layer.borderWidth = 0.3;
            cell.layer.borderColor = [[UIColor clearColor]CGColor];
            return cell;
        }else{
        ItemCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
        if (cell==nil)
        {
            cell=[[ItemCell alloc]initWithFrame:CGRectZero];

            cell.layer.borderWidth=2;
            cell.layer.borderColor=[UIColor blackColor].CGColor;

        }


        cell.btnLike.tag=indexPath.item;
        [cell.btnLike addTarget:self action:@selector(yourButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        NSMutableDictionary *itemDict=[clearanceoffersArray objectAtIndex:indexPath.row];

        if ([[itemDict objectForKey:@"is_in_wishlist"]integerValue] == 1) {
            [cell.btnLike setSelected: YES];
        }
        else {
            [cell.btnLike setSelected: NO];

        }

        NSString *urlString =[NSString stringWithFormat:@"%@",[itemDict objectForKey:@"main_image"]];

        urlString=[urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"prof img is %@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        [cell.imageVW sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place"]];



        //    cell.imageVW.image=[_Images_arr objectAtIndex:indexPath.row];
        cell.Name_lbl.text=[itemDict objectForKey:@"name"];
        cell.newprice_lbl.text=[NSString stringWithFormat:@"₹%@",[itemDict objectForKey:@"final_price"]];
        cell.oldPrice_lbl.text=[NSString stringWithFormat:@"₹%@",[itemDict objectForKey:@"price"]];
        cell.off_lbl.text=[NSString stringWithFormat:@"%@ off",[itemDict objectForKey:@"discount"]];



        NSAttributedString * title =
        [[NSAttributedString alloc] initWithString:cell.oldPrice_lbl.text
                                        attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [cell.oldPrice_lbl setAttributedText:title];


        /* if ([[itemDict objectForKey:@"reviews_count"] isEqual:[NSNull null]]) {
         cell.lblReviewsCount.text=@"( 0 )";

         }
         else
         {
         cell.lblReviewsCount.text=[NSString stringWithFormat:@"( %@ )",[itemDict objectForKey:@"reviews_count"]];

         }

         if ([[itemDict objectForKey:@"is_in_stock"] intValue]== 1) {
         cell.lblAvailability.text=@"In Stock";

         }
         else
         {
         cell.lblAvailability.text=@"Sold out";

         }

         cell.lblSeller.text=[NSString stringWithFormat:@"Seller : %@",[itemDict objectForKey:@"seller_info"]];

         */

        cell.layer.borderWidth = 0.3;
        cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];

            return cell;
            
        }
    }

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
    {


        if (collectionView == _clearanceofthesale_collecVW) {
            [self callProductDetailsService:[[clearanceoffersArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
            selectedProduct = [clearanceoffersArray objectAtIndex:indexPath.row];
            NSLog(@"selected product is %@",selectedProduct);
        } else {
           // NSDictionary *category_dict;

            NSDictionary *category_dict = [delasoffersArray objectAtIndex:indexPath.row];
            selectedProduct = category_dict;
            _WSConstScreenValue = @"Home";
            _WSConstSelectedCategoryID = [NSString stringWithFormat:@"%@",[category_dict objectForKey:@"category_id"]];
            [self performSegueWithIdentifier:@"detailSegue" sender:self];

        }
        
        
    }

-(void)callAddToWishListService:(NSDictionary *)postDict
{
    [APPDELEGATE showCustomLoader:self]; // Progress
    serviceconn = [[ServiceConnection alloc]init];
    serviceconn.delegate = self;
    ServiceType=@"AddToWishList";
    [serviceconn AddToWishList:postDict];
}


-(void)callRemoveFromWishListService:(NSString *)ProductId
{
    [APPDELEGATE showCustomLoader:self]; // Progress
    
    NSString * post = [[NSString alloc]initWithFormat:@"SID=%@&product=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"],ProductId];
    serviceconn = [[ServiceConnection alloc]init];
    serviceconn.delegate = self;
    ServiceType=@"RemoveFromWishList";
    [serviceconn RemoveFromWishList:post];
}

-(void)callProductDetailsService :(NSString *)ProductId
{
    
    if(apdl_detail1.net == 0)
    {

        UIAlertController*  alertController = [UIAlertController alertControllerWithTitle:apdl_detail1.alertTTL message:apdl_detail1.alertMSG preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [APPDELEGATE showCustomLoader:self]; // Progress
    
    serviceconn = [[ServiceConnection alloc]init];
    serviceconn.delegate = self;
    ServiceType=@"Details";
    [serviceconn GetProductDetails:ProductId];
    
}

-(void)yourButtonClicked:(UIButton*)sender
{
    indexVal=sender.tag;
    
    if(apdl_detail1.net == 0)
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:apdl_detail1.alertTTL message:apdl_detail1.alertMSG preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    else if ([[NSUserDefaults standardUserDefaults] stringForKey:@"email"] && ![[[NSUserDefaults standardUserDefaults] stringForKey:@"email"] isEqualToString:@""]) {
        
        
        NSMutableDictionary *selectedItemDict=[clearanceoffersArray objectAtIndex:indexVal];
        
        
        if ([[selectedItemDict objectForKey:@"is_in_wishlist"] integerValue] == 1)
        {
            
            //            [self callRemoveFromWishListService:[[_itemsListArr objectAtIndex:indexVal] objectForKey:@"item_id"]];
            UIAlertController*  alertController = [UIAlertController alertControllerWithTitle:@"FINGOSHOP" message:@"This Product is already in your wish list" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
        else
        {
            
            
            NSDictionary *post_dict = @{@"product":[[clearanceoffersArray objectAtIndex:indexVal] objectForKey:@"id"],@"customer_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"customer_id"],@"SID":[[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"]};
            
            [self callAddToWishListService:post_dict];
            
        }
        
        
        
        
    }
    else
    {
        
        UIAlertController*  alertController = [UIAlertController alertControllerWithTitle:@"Failed" message:@"Please login before adding item to your wishlist" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
    [self.clearanceofthesale_collecVW reloadData];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
        if ([segue.identifier isEqualToString:@"ProductDetail"]) {
            ProductDetailVC *mvc=[segue destinationViewController];
            mvc.productDetailsDict = [selectedProduct mutableCopy];

            mvc.productDetailsDict1 = [_selectedProductDict mutableCopy];
        }
        else if ([segue.identifier isEqualToString:@"ProductDetail1"]) {
            ProductDetailNewVC *mvc=[segue destinationViewController];
            mvc.productDetailsDict = [selectedProduct mutableCopy];
            mvc.productDetailsDict1 = [_selectedProductDict mutableCopy];
        }

    }


-(void)callGetDealsOffersList:(NSString*)post {
   // [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeBlack]; // Progress
     [APPDELEGATE showCustomLoader:self];
    serviceconn = [[ServiceConnection alloc]init];
    serviceconn.delegate = self;
    [serviceconn GetOffersList:post];
}


#pragma mark - ServiceConnection Delegate Methods

- (void)jsonData:(NSDictionary *)jsonDict
{
    //NSLog(@"Offers: %@",jsonDict);
    [APPDELEGATE removeCustomLoader:self];

    if ([ServiceType isEqualToString:@"Clearanceoftheday"] )
    {
        if (![jsonDict isEqual:[NSNull null]]) {
            [self.dealsoftheday_collecVW setHidden:YES];
            [self.clearanceofthesale_collecVW setHidden:NO];
            clearanceoffersArray = [jsonDict objectForKey:@"records"];
            [self.clearanceofthesale_collecVW reloadData];
        }
    }else if ([ServiceType isEqualToString:@"Dealsoftheday"]) {
        if (![jsonDict isEqual:[NSNull null]]) {
            [self.dealsoftheday_collecVW setHidden:NO];
            [self.clearanceofthesale_collecVW setHidden:YES];
            delasoffersArray = [jsonDict objectForKey:@"offer_banner"];
            [self.dealsoftheday_collecVW reloadData];
        }
    }else if ([ServiceType isEqualToString:@"RemoveFromWishList"]) {
        
        if ([[jsonDict objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            
            NSMutableDictionary *itemDict=[[clearanceoffersArray objectAtIndex:indexVal] mutableCopy];
            [itemDict setObject:@"0" forKey:@"is_in_wishlist"];
            [clearanceoffersArray replaceObjectAtIndex:indexVal withObject:itemDict];
            
            [self.clearanceofthesale_collecVW reloadData];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FINGOSHOP" message:[jsonDict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FINGOSHOP" message:[jsonDict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        
    }
    else if ([ServiceType isEqualToString:@"AddToWishList"]) {
        
        
        if ([[jsonDict objectForKey:@"status"] isEqualToString:@"SUCCESS"]) {
            
            NSMutableDictionary *itemDict=[[clearanceoffersArray objectAtIndex:indexVal] mutableCopy];
            [itemDict setObject:@"1" forKey:@"is_in_wishlist"];
            [clearanceoffersArray replaceObjectAtIndex:indexVal withObject:itemDict];
            
            [self.clearanceofthesale_collecVW reloadData];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FINGOSHOP" message:[jsonDict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FINGOSHOP" message:[jsonDict objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        
        
    }else if ([ServiceType isEqualToString:@"Details"]) {
        
        
        _selectedProductDict = [jsonDict mutableCopy];
        
        
        NSArray *attributeArr = (NSArray *)[_selectedProductDict objectForKey:@"configurable_attributes"];
        
        /*    if ([attributeArr count] == 0 || [attributeArr count] == 2) {
         [self performSegueWithIdentifier:@"ProductDetail" sender:self];
         }else{
         
         [self performSegueWithIdentifier:@"ProductDetail1" sender:self];
         }
         */
        
        if ([attributeArr count]>0) {
            [self performSegueWithIdentifier:@"ProductDetail1" sender:self];
            
        }
        else {
            [self performSegueWithIdentifier:@"ProductDetail" sender:self];
        }
        
        
    }
    
        
   
//
}


- (void)errorMessage:(NSString *)errMsg
{
    [APPDELEGATE removeCustomLoader:self];
}

@end
