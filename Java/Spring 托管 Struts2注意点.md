### Spring 托管 Struts2注意点：

####Struts2--Spring项目介绍：

1. 托管，也就是spring去自动装配Action对象，spring去管理Action对象的生命周期。

2. ```java
   
   spring.xml配置bean对象
   <bean id="ProjectOperatorAction" class="com.action.ProjectOperatorAction" scope="prototype"></bean>
   struts.xml配置action
       <package name="userAction"  namespace ="/"  extends="json-default" >
      <!-- setting action -->
       <action name="xxx" class="JsonOperatorAction" method="frontJsonParse">
             <result type="json"></result>
       </action>
   ```

#### Spring托管Struts2说明：

1.Struts Action说明：

> **struts2的Action默认是多实例的并非单例，也就是每次请求产生一个Action的对象,即每次访问的参数都被封装在Action的成员变量中。**
>
> struts2中Action多实例的优势在于是线程安全的，每次请求都会创建单独的Action类来处理，而不用想servlet一样担心线程安全问题。

2.Spring

> **Spring管理Struts2的Action自动设置为单例。这样Action的生命周期为服务器生命周期，也就是说不关闭应用服务器，Action一直存在，Action中的属性也一直存在。 **

如果使用Spring托管Struts2会导致单例。会出现如下问题：

>- 1) Struts2的Action是单例,其中的FieldError,actionerror中的错误信息会累加, 即使再次输入了正确的信息,也过不了验证.
>- 2) Struts2的Action是有状态的,他有自己的成员属性, 所以在多线程下,会有线程安全问题，这是最大的问题。



我的项目是单机版的，本来无所谓线程问题，但是对于一个请求多次点击，则会出现使用一个实例两次，若此函数处理比较费时（同时响应式异步的），导致返回一个响应返回两条数据，最终报错。类似第一种情况

####补充：

[Spring的Scope](https://www.cnblogs.com/lonecloud/p/5745902.html)

* prototype 
* singleton
* session
* request
* global session 

[Servlet 九大对象和四个作用域](https://www.cnblogs.com/vice/p/9125431.html)

* request              请求对象　                类型 javax.servlet.ServletRequest           作用 Request 
* response             响应对象                 类型 javax.servlet.SrvletResponse           作用域 Page 
* pageContext      页面上下文对象           类型 javax.servlet.jsp.PageContext          作用域 Page 
* session                会话对象                 类型 javax.servlet.http.HttpSession         作用域 Session  
* application         应用程序对象             类型 javax.servlet.ServletContext             作用域 Application 
* out                      输出对象                  类型 javax.servlet.jsp.JspWriter               作用域 Page 
* config                配置对象                  类型 javax.servlet.ServletConfig               作用域 Page 
* page                   页面对象                  类型 javax.lang.Object                              作用域 Page 
* exception          例外对象                  类型 javax.lang.Throwable                        作用域 page 