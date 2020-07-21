## Nginx

#### 1. conf

```nginx
    location /test {
        proxy_pass http://localhost:7070/xx/;
    }
    location /test/mongoose {
        proxy_pass http://localhost:18090/mongoose/;
    }
#static page
 	location / {
            root   /home/ngi-novisualization-cros;
            index  index.html index.htm;
        }

```


```
rewrite ^/(.*) http://www.czlun.com/$1 permanent;

说明：                                        

rewrite为固定关键字，表示开始进行rewrite匹配规则

regex部分是 ^/(.*) ，这是一个正则表达式，匹配完整的域名和后面的路径地址

replacement部分是http://www.czlun.com/$1 $1，是取自regex部分()里的内容。匹配成功后跳转到的URL。

flag部分 permanent表示永久301重定向标记，即跳转到新的 http://www.czlun.com/$1 地址上
```

nginx -s stop # 立即停止
nginx -s quit # 停止，在Nginx停止前会等待当前正在进行的任务
nginx -s reload # 重新加载配置文件



#### 2.资料

[Nginx URL重写（rewrite）](https://www.cnblogs.com/zuxing/articles/9686144.html)

[Nginx 负载均衡介绍](https://blog.csdn.net/qq_36125138/article/details/84144932)

