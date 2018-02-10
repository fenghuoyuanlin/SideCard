//
//  LYWalletViewController.m
//  GuanruAppDemo
//
//  Created by 刘园 on 2017/10/23.
//  Copyright © 2017年 guanrukeji. All rights reserved.
//

#import "LYWalletViewController.h"
// Controllers
#import "LYMyAccountController.h"
#import "LYMyRateController.h"
#import "LYUpdateController.h"
#import "LYCreditCardController.h"
#import "LYMoreServiceController.h"
#import "LYMyProfitController.h"
#import "LYMerchantController.h"
#import "LYBillSearchController.h"
#import "LYCreditLoansController.h"
#import "LYDataCenterController.h"
#import "LYLinkController.h"
#import "LYQrcodePayController.h"
#import "LYNavigationController.h"
#import "LYWalletServiceController.h"
#import "LYFillDataController.h"
#import "LYLoginViewController.h"
#import "LYEnterViewController.h"
#import "LYWalletServiceController.h"
#import "LYPaymentDetailController.h"
#import "LYShareViewController.h"
// Models
#import "LYWalletItem.h"
#import "LYMoreItem.h"
// Views
#import "LYWalletItemCell.h"
#import "LYRecommendCell.h"
#import "LYCycleCell.h"
#import "LYMoreItemCell.h"
#import "LYWalletHeader.h"
#import "LYTopLineFootView.h"
// Vendors
#import <MJExtension.h>
#import "SubLBXScanViewController.h"
// Categories

// Others

@interface LYWalletViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

//collectionView
@property(nonatomic, strong) UICollectionView *collectionView;
//10个属性数组
@property(nonatomic, strong) NSMutableArray<LYWalletItem *> *walletArr;
//推荐商品属性数组
@property(nonatomic, strong) NSMutableArray<LYMoreItem *> *moreArr;

@property(nonatomic, strong) LYWalletHeader *headerView;

@end

//cell
static NSString *const LYWalletItemCellID = @"LYWalletItemCell";
static NSString *const LYRecommendCellID = @"LYRecommendCell";
static NSString *const LYCycleCellID = @"LYCycleCell";
//static NSString *const LYMoreItemCellID = @"LYMoreItemCell";

//footer
static NSString *const LYTopLineFootViewID = @"LYTopLineFootView";

@implementation LYWalletViewController

#pragma mark - lazyLoad

-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0, 125, ScreenW, ScreenH - 189);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        //注册
        //cell
        [_collectionView registerClass:[LYWalletItemCell class] forCellWithReuseIdentifier:LYWalletItemCellID];
        [_collectionView registerClass:[LYRecommendCell class] forCellWithReuseIdentifier:LYRecommendCellID];
        [_collectionView registerClass:[LYCycleCell class] forCellWithReuseIdentifier:LYCycleCellID];
//        [_collectionView registerClass:[LYMoreItemCell class] forCellWithReuseIdentifier:LYMoreItemCellID];
        
        //footer
        //foot
        [_collectionView registerClass:[LYTopLineFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:LYTopLineFootViewID];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"]; //分割线
        
    }
    return _collectionView;
}

-(LYWalletHeader *)headerView
{
    if (!_headerView)
    {
        _headerView = [[LYWalletHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 125)];
        
            __weak typeof(self) weakSelf = self;
            _headerView.faceBtnClickBlock = ^{
                NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"userphone"];
                if (str)
                {
                    [weakSelf.navigationController pushViewController:[[LYLinkController alloc] init] animated:YES];
                }
                else
                {
                    [weakSelf rightLogin];
                }
            };
            
            _headerView.qrcodeBtnClickBlock = ^{
                NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"userphone"];
                if (str)
                {
                    [weakSelf.navigationController pushViewController:[[LYEnterViewController alloc] init] animated:YES];
                }
                else
                {
                    [weakSelf rightLogin];
                }
            };
    
        
        
    }
    return _headerView;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置导航栏字体颜色
    UIColor * naiColor = [UIColor whiteColor];
    attributes[NSForegroundColorAttributeName] = naiColor;
    attributes[NSFontAttributeName] = PFR20Font;
    self.navigationController.navigationBar.barTintColor = RGBA(249, 133, 45, 1.0);
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    // 这样设置状态栏样式是白色的
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 设置导航栏字体颜色
    UIColor * naiColor = [UIColor blackColor];
    attributes[NSForegroundColorAttributeName] = naiColor;
    attributes[NSFontAttributeName] = PFR20Font;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    // 这样设置状态栏样式是黑色的
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DCBGColor;
    [self.view addSubview:self.headerView];
    self.collectionView.backgroundColor = DCBGColor;
    [self setUpData];
}

#pragma mark - 加载数据
-(void)setUpData
{
    _walletArr = [LYWalletItem mj_objectArrayWithFilename:@"WalletGrid.plist"];
    
    _moreArr = [LYMoreItem mj_objectArrayWithFilename:@"Grid.plist"];
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (section == 0) ? 3 : (section == 2) ? 1 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0)
    {
        LYWalletItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LYWalletItemCellID forIndexPath:indexPath];
        cell.gridItem = _walletArr[indexPath.row];
        gridcell = cell;
    }
    else if(indexPath.section == 1)
    {
        LYRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LYRecommendCellID forIndexPath:indexPath];
        gridcell = cell;
    }
    else if (indexPath.section == 2)
    {
        __weak typeof(self) weakSelf = self;
        LYCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LYCycleCellID forIndexPath:indexPath];
        cell.cycleImageClickBlock = ^{
            LYWalletServiceController *VC = [[LYWalletServiceController alloc] init];
            VC.urlString = @"http://www.ssk.tukaqianbao.com/AboutUs/about_us.html";
            VC.title = @"兔卡钱包";
            [weakSelf.navigationController pushViewController:VC animated:YES];
        };
        gridcell = cell;
    }
    return  gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter)
    {
        if (indexPath.section == 0)
        {
            __weak typeof(self) weakSelf = self;
            LYTopLineFootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:LYTopLineFootViewID forIndexPath:indexPath];
            footerView.questionClickBlock = ^{
                LYWalletServiceController *serVC = [[LYWalletServiceController alloc] init];
                serVC.title = @"常见问题";
                serVC.urlString = @"http://www.1shouyin.com/AboutUs/question.html";
                [weakSelf.navigationController pushViewController:serVC animated:YES];
            };
            reusableView = footerView;
        }
        else
        {
            UICollectionReusableView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
            footview.backgroundColor = DCBGColor;
            reusableView = footview;
        }
        
    }
    return reusableView;
    
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)//属性
    {
        return CGSizeMake(ScreenW / 3 , ScreenW / 4);
    }
    if (indexPath.section == 1)//属性
    {
        return (iphone5) ? CGSizeMake(ScreenW, 130) : CGSizeMake(ScreenW, 160);
    }
    if (indexPath.section == 2)//猜你喜欢
    {
        return CGSizeMake(ScreenW, ScreenW / 3);
    }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return (section == 0) ? CGSizeMake(ScreenW, 60) : CGSizeMake(ScreenW - 30, 15);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 0 || section == 2) ? 0 : 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 0) ? 3 : (section == 2) ? 0 : 0;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了10个第%zd属性第%zd",indexPath.section,indexPath.row);
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"userphone"];
    if (indexPath.section == 2)
    {
//        [DCSpeedy alertMes:@"敬请期待"];
    }
    else
    {
        if (str)
        {
            if (indexPath.section == 0)
            {
                if (indexPath.row == 3)
                {
                    //            [self.navigationController pushViewController:[[LYMyAccountController alloc] init] animated:YES];
                }
                else if (indexPath.row == 4)
                {
                    //            [self.navigationController pushViewController:[[LYMyRateController alloc] init] animated:YES];
                }
                else if (indexPath.row == 5)
                {
                    //            [self.navigationController pushViewController:[[LYUpdateController alloc] init] animated:YES];
                }
                else if (indexPath.row == 1)
                {
                    [self.navigationController pushViewController:[[LYFillDataController alloc] init] animated:YES];
                    
                }
                else if (indexPath.row == 0)
                {
                    [self.navigationController pushViewController:[[LYMerchantController alloc] init] animated:YES];
                }
                else if (indexPath.row == 2)
                {
                    [self.navigationController pushViewController:[[LYBillSearchController alloc] init] animated:YES];
                }
            }
            else if (indexPath.section == 1)
            {
                [self setUpAgentIdConnect];
//                [self.navigationController pushViewController:[[LYShareViewController alloc] init] animated:YES];
            }
        }
        else
        {
            [self rightLogin];
        }
    }
    
    
}



#pragma mark - 二维码扫一扫
-(void)richScanItemClick
{
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    SubLBXScanViewController *vc = [[SubLBXScanViewController alloc]init];
    vc.title = @"扫码付";
    vc.style = style;
    vc.isQQSimulator = YES;
    
     LYNavigationController *nav = [[LYNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
    vc.scanResult = ^(NSString *strScanned){
        NSLog(@"%@", strScanned);
    };
    
}

#pragma mark - 获取代理商接口
-(void)setUpAgentIdConnect
{
    __weak typeof(self) weakSelf = self;
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    NSDictionary *dic = @{
                          @"agentid": userid
                          };
    [AFOwnerHTTPSessionManager getAddToken:GetAgentUrl Parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0000"])
        {
            NSString *url = responseObject[@"Data"][@"url"];
            LYWalletServiceController *walletService = [[LYWalletServiceController alloc] init];
            walletService.urlString = url;
            walletService.title = @"设置下级代理商结算费率";
            [weakSelf.navigationController pushViewController:walletService animated:YES];
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 立刻登录
-(void)rightLogin
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"我们还没有找到您的账户信息，请马上登录！" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击确认");
        LYNavigationController *nav = [[LYNavigationController alloc] initWithRootViewController:[[LYLoginViewController alloc] init]];
        [self presentViewController:nav animated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
