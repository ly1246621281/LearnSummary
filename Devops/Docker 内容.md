## Docker 内容

### 1.命令使用

#### 1. 镜像操作

> docker images
>
> docker pull
>
> \1. 启动docker服务
>
> service docker restart
>
> \2. 登录 hr人事在线用户名和密码
>
> docker login docker.artxa.zte.com.cn
>
> \3. 下载镜像
>
> \#docker pull docker.nj.artnj.zte.com.cn/cca/public/klocwork:11.3-centos-7.3.1611-zte
>
> docker pull docker.artxa.zte.com.cn/cci/wireless-inom-inoa/build_centos_klocwork:verifyci
>
> docker pull docker.artxa.zte.com.cn/cci/wireless-zxwng-mp/zxwng_build_centos:wng
>
> docker pull docker.artxa.zte.com.cn/cci/wireless-zxwng-mp/zxwng_build_centos:wng
>
> docker pull docker.artnj.zte.com.cn/cca/wng_klocwork/zxwng_build_centos_klocwork:wng_kw
>
> 4. 删除镜像
>
>    docker rmi xxx （镜像id或者name）
>
> 5. 镜像重命名
>
>    docker ==tag== 538665 unipos-mongoose-release-docker.artxa.zte.com.cn/test/nginx:z20191017

#### 2.容器操作

> 1.docker ps -a 查看所有容器
>
> 2.docker ps 查看打开的容器
>
> 3.docker rm 容器id 删除
>
> 4.登录
>
> docker run -i -t --name wng_kw_verifyci docker.artxa.zte.com.cn/cci/wireless-inom-inoa/build_centos_klocwork:verifyci /bin/bash
>
> 
>
> docker run -i -t --name appplat docker pull docker.artxa.zte.com.cn/cci/wireless-zxwng-mp/zxwng_build_centos:wngverifyci /bin/bash
>
> 
>
> docker run -i -t --name wng_cca_kw docker.artnj.zte.com.cn/cca/wng_klocwork/zxwng_build_centos_klocwork:wng_kw /bin/bash
>
> 
>
> 后续登录
>
> docker start wng_cca_kw
>
> docker attach wng_cca_kw
>
> 
>
> 5.查询容器id
>
> docker ps -a
>
> 
>
> 5.==推送==
>
> *Commit: 提交容器，将镜像新增内容提交，用于Push   作用也可用于重命名仓库、Tag名*  不同于docker tag
>
>  **docker commit -m "hub docker 更新20191018最新代码库" -a "zk 10224556" 39f5d unipos-mongoose-release-docker.artxa.zte.com.cn/hub/hub-mongoose:mongoose-hub-2019101801**
>
> 
>
> docker commit 6d22a43a0fb9(容器id) docker.artxa.zte.com.cn/cci/wireless-zxwng-mp/zxwng_build_centos_klocwork:verifyci_V1
>
> docker push docker.artxa.zte.com.cn/cci/wireless-zxwng-mp/zxwng_build_centos_klocwork:verifyci_V1
>
> 
>
> docker commit 6413f3d57dfa docker.artnj.zte.com.cn/cca/wng_klocwork/zxwng_build_centos_klocwork:wng_kw_20190302
>
> docker push docker.artnj.zte.com.cn/cca/wng_klocwork/zxwng_build_centos_klocwork:wng_kw_20190302
>
> 6.查看容器环境变量
>
> docker exec 9198（容器ID） env

### 2.Dockerfile

根据镜像编译容器的文件命令，同MakeFile文件

==文件名为Dockerfile，不能修改==

```dockerfile
#Mongoose Dockerfile set ENV
#依托镜像名
From docker.artnj.zte.com.cn/cca/mongoose/klocwork_mongoose_maven:mongoose_kw_20190706
MAINTAINER zhangkai 10224556

# copy文件至容器内
COPY test.txt /home/  
# 设置环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64
ENV MAVEN_HOME=/usr/local/maven/apache-maven-3.6.1
ENV PATH=$PATH:/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64/bin:/usr/local/maven/apache-maven-3.6.1/bin
RUN echo 'hello docker!' \
    >> /home/test.txt

```

**修改Docker容器环境变量：**

Docker启动默认不会去读/etc/profile这些配置文件（启动docker时后应该是非交互方式进入bash，因此就不会读取profile文件，要从~/.bashrc文件下才能加载。）

可以在这个镜像基础上，用Dockerfile构建一个配置好环境变量的新镜像。在Dockerfile里使用==ENV指令==，可以持久保存环境变量，当使用这个新镜像创建的容器时，ENV设置的环境变量就会生效了

### 3.遇到的问题

> 1. 镜像太大，磁盘空间不足
>
>    https://blog.csdn.net/qq_37674858/article/details/79976751
>
> 2. 环境变量问题
>
>    https://www.jianshu.com/p/34c5b02c0975
>
>    二、Linux下各种profile文件和bashrc文件的总结
>
>    1./etc/profile 
>    用来设置系统环境参数，比如$PATH. 这里面的环境变量是对系统内所有用户生效的。
>    2./etc/bashrc 
>    这个文件设置系统bash shell相关的东西，对系统内所有用户生效。只要用户运行bash命令，那么这里面的东西就在起作用。
>    3.~/.bash_profile 
>    用来设置一些环境变量，功能和/etc/profile 类似，但是这个是针对用户来设定的，也就是说，你在/home/user1/.bash_profile 中设定了环境变量，那么这个环境变量只针对 user1 这个用户生效.
>    4.~/.bashrc 
>    作用类似于/etc/bashrc, 只是针对用户自己而言，不对其他用户生效。  
>    另外/etc/profile中设定的变量(全局)的可以作用于任何用户,而~/.bashrc等中设定的变量(局部)只能继承/etc/profile中的变量,他们是”父子”关系。
>
>    最终要的是下面这一句：
>    ~/.bash_profile 是交互式、login 方式进入 bash 运行的，意思是只有用户登录时才会生效。 
>    ~/.bashrc 是交互式 non-login 方式进入 bash 运行的，用户不一定登录，只要以该用户身份运行命令行就会读取该文件。 
>    按照上面的观点，启动docker时后应该是非交互方式进入bash，因此就不会读取profile文件，要从~/.bashrc文件下才能加载。
>    --------------------- 
>    作者：lwcaicsdn 
>    来源：CSDN 
>    原文：https://blog.csdn.net/lwcaiCSDN/article/details/87862025 
>    版权声明：本文为博主原创文章，转载请附上博文链接！