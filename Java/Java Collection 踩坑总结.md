## Java Collection 踩坑总结

#### 1.List addAll

**底层实现：**

```
System.arraycopy(dataType[] srcArray,int srcIndex,int destArray,int destIndex,int length)
```

> 其中，srcArray 表示源数组；srcIndex 表示源数组中的起始索引；destArray 表示目标数组；destIndex 表示目标数组中的起始索引；length 表示要复制的数组长度。
>
> 使用此方法复制数组时，length+srcIndex 必须小于等于 srcArray.length，同时 length+destIndex 必须小于等于 destArray.length。
>
> **无法满足深拷贝**

**数组copy的四种方式**

> 1.Arrays 类的 copyOf() 方法与 copyOfRange() 方法都可实现对数组的复制。copyOf() 方法是复制数组至指定长度，copyOfRange() 方法则将指定数组的指定长度复制到一个新数组中。
>
> 2.System.arraycopy()
>
> 3.Object.clone()

#### 2.深拷贝和浅拷贝（原型设计模式）

**出现情形：**

> 1.Student类中注入person类
> 2.List<person>
> 	上述两种对象 出现将一个对象赋值给另一对象时，使用=赋值或者new List --add时
>
> eg:``` student s1=new student("zhangsan",1,p); student s2=(student)s1.clone();``` 

##### 浅拷贝

> **clone（）方法，他并不是将对象的所有属性全拷贝过来，而是选择性拷贝，拷贝规则为：**
>
> **1）基本类型，只拷贝其值。**
>
> **2）实例对象，拷贝其地址引用，新拷贝对象原对象共用该实例。**
>
> **3）字符串，拷贝地址引用，修改时会从字符串常量池中新生一个原字符串不变。**
>
> **所以，基本类型和字符串一样均为值拷贝，引用对象为引用拷贝。**

<br>

#####深拷贝

> **1. implements Cloneable**
>
> 重写clone方法，并对每一个引用类型进行深度clone.
>
> ```java
> public Object clone() {
>     person o = null;
>     try {
>         o = (person) super.clone();
>         if(arr!=null)
>         {
>             Object obj=arr.clone();
>             o.arr=(String[])obj;
>         }
>     } catch (CloneNotSupportedException e) {
>         e.printStackTrace();
>     }
>     return o;
> }
> ```
>
> 必须：实现 Cloneable接口。优缺点：定制化强，但如果多个类对象均需手动实现Clone接口以及实现。
>
> **2.序列化 implements Serializable**
>
> 也就是序列化为二进制流，然后再反序列化为对象，
>
> ```java
> public class CloneUtils {
>     @SuppressWarnings("unchecked")
>     public static <T extends Serializable> T clone(T obj){
>         T cloneObj = null;
>         try {
>             //写入字节流
>             ByteArrayOutputStream out = new ByteArrayOutputStream();
>             ObjectOutputStream obs = new ObjectOutputStream(out);
>             obs.writeObject(obj);
>             obs.close();
>         //分配内存，写入原始对象，生成新对象
>         ByteArrayInputStream ios = new ByteArrayInputStream(out.toByteArray());
>         ObjectInputStream ois = new ObjectInputStream(ios);
>         //返回生成的新对象
>         cloneObj = (T) ois.readObject();
>         ois.close();
>     } catch (Exception e) {
>         e.printStackTrace();
>     }
>     return cloneObj;
> }
> }
> ```
> 必须：待序列化对象实现Serializable接口
>
> 第三方工具：Spring Core
>
> ```java
> org.springframework.util;
> SerializationUtils.deserialize（）SerializationUtils.serialize（）
> ```
>
> ==引入：transient==  :序列化时此对象不进入序列化。

##### 基于反射

BeanUtil, Spring 核心包提供的一个工具类，基本原理就是获取class实例化，在通过反射整体复制属性

``` BeanUtils.copyProperties(p11,p21);```

#### 3.排序

**equals  hascode **

Hashcode--->hashset hashtable hashMap ，去重操作，然后比较equals。

equals ---> List 等比较元素

学习使用Stream().sort().排序



![img](http://img.blog.csdn.net/20160706172512559?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

HashSet ->AbstractSet --->Set



