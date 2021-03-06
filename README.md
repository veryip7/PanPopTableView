# PanPopTableView -- help
1. 在项目中可能会遇到层级较多，且层级数不固定的情况，比如地域展示(省->市->县->镇等)，它们可以在新的页面展示，但会占用较多资源，如果在同一页面展示，可能又有侧滑返回上一级的需求，而系统的滑动返回会直接返回到前一个页面，此时就需要给UITableView定制一个滑动返回的功能。

2. PanPopTableView继承于UITableView，支持单个页面tableView多级数据展示的滑动返回，因iOS系统的滑动返回是支持7.0版本以上的，这里和系统一样也只支持7.0以上，如果系统版本低于7.0，使用PanPopTableView跟普通UITableView没有区别。

3. 实现只有一个类：PanPopTableView

4. 可以看看demo项目，PanPopTableView.h文件中对各方法也有比较详细的解释。

5. 使用方法（listTableView是PanPopTableView的实例）：
    a. 给listTableView设置滑动返回的回调block。

    __weak typeof(self) weakSelf = self;

    listTableView.popReturn = ^(){

        [weakSelf backButtonClick:nil];//--------------!!!!!!!!!!!!!!

    };

    b. 将要进入下一页时调用nextPage

    -(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        City *c = currentCitys[indexPath.row];

        if (c.subCities) {//如果有子层级

            [listTableView nextPage];//--------------!!!!!!!!!!!!!! 

        }

        return indexPath;

    }

    c. 返回上一页后调用frontPage方法，这个方法添加在返回按钮事件中 。

    d. viewDidLoad中添加：

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {//--------------!!!!!!!!!!!!!! 

        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;

    }

    e. viewDidAppear中调用setIsEnableSystemPopReturn设置是否禁用系统的滑动返回：

    -(void)viewDidAppear:(BOOL)animated{

        [super viewDidAppear:animated];

        [listTableView setIsEnableSystemPopReturn];//--------------!!!!!!!!!!!!!!

    }

    f. 在viewWillDisappear中添加：

    -(void)viewWillDisappear:(BOOL)animated{

        [super viewWillDisappear:animated];

        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {//--------------!!!!!!!!!!!!!!

        self.navigationController.interactivePopGestureRecognizer.enabled = YES;

        }

    }
