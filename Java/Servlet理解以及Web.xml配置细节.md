## Servlet理解以及Web.xml配置细节

### 0. Servlet理解

> - Java Servlet是与平台无关的服务器端组件，运行于Servlet容器中(如Tomcat)，Servlet容器负责Servlet和客户端的通信以及调用Servlet的方法，Servlet和客户端的通信采用“请求/响应”的模式。
>
> - Servlet的框架由两个包组成：javax.servlet和javax.servlet.http。在javax.servlet包中定义了所有Servlet类必须实现或扩展的通用接口和类。在javax.servlet.http包中定义了采用HTTP协议通信的HttpServlet类。
>
>   Servlet框架的核心是javax.servlet.Servlet接口，所有的Servlet类都必须实现这个接口。Servlet接口定义的方法如下：
>
>   1、init方法，负责初始化Servlet对象。
>
>   2、service方法，负责响应客户端的请求。
>
>   3、destroy方法，当Servlet对象退出生命周期时，负责释放占用的资源。
>
>   4、getServletConfig方法，获得ServletConfig接口，可以得到Servlet的相关参数。
>
>   5、getServletInfo方法，获得Servlet的相关信息。

### 1. Servlet3.0比Servlet2.5增加特性

==*==Servlet 3.0 作为 Java EE 6 规范体系中一员，随着 Java EE 6 规范一起发布。(JDK1.6才支持Servlet3.0)

> - **异步处理支持**：有了该特性，Servlet 线程不再需要一直阻塞，直到业务处理完毕才能再输出响应，最后才结束该 Servlet 线程。在接收到请求之后，Servlet 线程可以将耗时的操作委派给另一个线程来完成，自己在不生成响应的情况下返回至容器。针对业务处理较耗时的情况，这将大大减少服务器资源的占用，并且提高并发处理速度；
>
>   ==` ``<``async-supported``>true</``async-supported``>`==
>
> - **新增的注解支持**：该版本新增了若干注解，用于简化 Servlet、过滤器（Filter）和监听器（Listener）的声明，这使得 web.xml 部署描述文件从该版本开始不再是必选的了；
>
>   @WebServlet(urlPatterns = "/demo", asyncSupported = true)
>
> - **可插性支持**：熟悉 Struts2 的开发者一定会对其通过插件的方式与包括 Spring 在内的各种常用框架的整合特性记忆犹新。将相应的插件封装成 JAR 包并放在类路径下，Struts2 运行时便能自动加载这些插件。现在 Servlet 3.0 提供了类似的特性，开发者可以通过插件的方式很方便的扩充已有 Web 应用的功能，而不需要修改原有的应用；
>
>   web-fragment.xml
>
>   > 现在，为一个 Web 应用增加一个 Servlet 配置有如下三种方式 ( 过滤器、监听器与 Servlet 三者的配置都是等价的，故在此以 Servlet 配置为例进行讲述，过滤器和监听器具有与之非常类似的特性 )：
>   >
>   > - 编写一个类继承自 HttpServlet，将该类放在 classes 目录下的对应包结构中，修改 web.xml，在其中增加一个 Servlet 声明。这是最原始的方式；
>   > - 编写一个类继承自 HttpServlet，并且在该类上使用 @WebServlet 注解将该类声明为 Servlet，将该类放在 classes 目录下的对应包结构中，无需修改 web.xml 文件。
>   > - 编写一个类继承自 HttpServlet，将该类打成 JAR 包，并且在 JAR 包的 META-INF 目录下放置一个 web-fragment.xml 文件，该文件中声明了相应的 Servlet 配置。

### 3.Web.xml各功能配置

**web.xml的加载顺序是:<context-param>**->**<listener>**->**<filter>**->**<servlet>。其中，如果web.xml中出现了相同的元素，则按照在配置文件中出现的先后顺序来加载**。

### 

> 1. ### 《context-param></context-param》配置参数
>
> ```xml
> 
> <!--***********************上下文初始化参数ServletContext***************************--> 
> <context-param>  
>     <param-name>webAppRootKey</param-name>    Servlet项目标识
>     <param-value>business.root</param-value>  
> </context-param>  
> <!-- spring config -->  
> <context-param>  
>     <param-name>contextConfigLocation</param-name>   
>     <param-value>/WEB-INF/spring-configuration/*.xml</param-value>  
> </context-param> 
> ```
>
> 2. ### 《listener></listener》 监听器，意为随着Servlet应用同步启动以及销毁。
>
> ```xml
> 
> <!--****************************监听器配置*********************************-->  
> <!-- Spring的log4j监听器 -->  
> <listener>  
>     <listener-class>org.springframework.web.util.Log4jConfigListener</listener-class>  
> </listener>  
> <listener>  
>     <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>  
> ```
>
> 3. ### 《filter></filter》 过滤器
>
> 4. 《Servlet></Servlet》
>
> ```xml
> <!-- Spring view分发器  对所有的请求都由business对应的类来控制转发 -->  
> <servlet>  
>     <servlet-name>business</servlet-name>  
>     <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>  
>     <init-param>  
>       <param-name>publishContext</param-name>  
>       <param-value>false</param-value>  
>     </init-param>  
>     <load-on-startup>1</load-on-startup>   表示启动容器时，初始化Servlet，同listener
> </servlet>
> <servlet-mapping>
>     <servlet-name>business</servlet-name>
>     <url-pattern>/axis2-admin/*</url-pattern>
> </servlet-mapping>
> ```
>
> 

### 4.参考资料

1.[Servelt3.0特性理解](https://blog.csdn.net/fuxiaohui/article/details/72762213)

2.[Web.xml配置详解](https://blog.csdn.net/ahou2468/article/details/79015251)