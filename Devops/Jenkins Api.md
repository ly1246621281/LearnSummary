## Jenkins Api

#### 1.进入API内

http://10.92.180.116:9090/job/Mongoose_Build/api/json?pretty=true

#### 2.筛选提取需要信息

http://10.92.180.116:9090/job/Mongoose_Build/api/json?pretty=true&tree=displayName[*],url[*],builds[displayName[*],result[*],timestamp[*]]

![1554277203548](C:\Users\10224556\Documents\Scrshot\jenkins01.png)

#### 3.学习网站

[Jenkins API学习](https://www.cnblogs.com/zjsupermanblog/archive/2017/07/26/7238422.html)

