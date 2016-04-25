#自制干货客户端——“千货"

闲暇之余，使用著名的干货API写了个客户端，取名“千货”（有一种浓浓的山寨味），不过好用就好啦，以后在里面看看博客（妹子）什么的就很方便啦。
##三大板块
###学习时间
每日各种教程博客应有尽有。
![image](https://github.com/deeepthinking/QianHuo/blob/master/screenshoot/learn.gif)
###休息时间
每日的干妹子和休息视屏，学习之余放松心情。
![image](https://github.com/deeepthinking/QianHuo/blob/master/screenshoot/rest.gif)
###我喜欢的
收藏你喜欢的文章，让你时刻回忆和复习。
![image](https://github.com/deeepthinking/QianHuo/blob/master/screenshoot/like.gif)

##开发总结 
- 采用MVVM分层；层与层之间交流使用KVO（FB的KVOController库）
- 网络请求使用的是AFNetworking
- 数据库归档使用JKDBModel模型数据库
- 自动布局使用Masonry
- 图片加载使用SDWebImage
- 上拉刷新使用SVPullToRefresh
- 下拉刷新是苹果自带的refreshControl


