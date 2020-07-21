

## 密码编码Java实践

密码编码主要涉及以下三种：

哈希散列（签名）：对字符串求散列值，不可逆。常用于防止篡改，保证数据完整性，不可否认性。常见算法： MD5(128)，SHA1(160),  SHA-224、SHA-256、SHA-384，和SHA-512并称为SHA-2。

对称加密：加密和解密相同秘钥。保证数据机密性。常见算法：DES，AES, XTEA, 3DES。

非对称加密： 公钥加密 私钥加密， 加密和解密秘钥不同。保证数据机密性。常见算法：RSA。

### 1.哈希散列

**MD5**、**SHA**、**HMAC**等加密算法，可谓是非可逆加密，就是不可解密的加密方法。

  SHA(Secure Hash Algorithm，安全散列算法），数字签名等密码学应用中重要的工具，被广泛地应用于电子商务等信息安全领域。虽然，SHA与MD5通过碰撞法都被破解了， 但是SHA仍然是公认的安全加密算法，较之MD5更为安全。 

![各种Java加密算法](C:\Users\10224556\Desktop\Mongoose需求\Mongoose举证\安全小课题\20140412114510_4681.jpg)  

```java
	/**
     * SHA加密
     * 
     * @param data
     * @return
     * @throws Exception
     */
    public static byte[] encryptSHA(byte[] data) throws Exception {
        MessageDigest sha = MessageDigest.getInstance(“SHA”);
        sha.update(data);
        return sha.digest();
    }
}
```

```java
 @Test
    public void testSHA(){
        String inputStr = "SHA111";
        byte[] inputData = inputStr.getBytes();
        try {
            System.out.println("原文：\t" + inputStr);
            byte[] output = codeEncypt.encryptSHA(inputData);
            System.out.println("散列后：\t" + codeEncypt.encryptBASE64(output));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
```

![1573734317245](C:\Users\10224556\Desktop\Mongoose需求\Mongoose举证\安全小课题\1573734317245.png)

### 2.传统加密，对称加密

**对称加密就是只有一个密钥，加密解密使用同一个密钥。**

**DES** 
DES-Data Encryption Standard,即数据加密算法。是IBM公司于1975年研究成功并公开发表的。DES算法的入口参数有三个:Key、Data、Mode。其中 Key为8个字节共64位,是DES算法的工作密钥;Data也为8个字节64位,是要被加密或被解密的数据;Mode为DES的工作方式,有两种:加密 或解密。 
        DES算法把64位的明文输入块变为64位的密文输出块,它所使用的密钥也是64位。 

​		其实DES有很多同胞兄弟，如DESede(TripleDES)、AES、Blowfish、RC2、RC4(ARCFOUR)。这里就不过多阐述了，大同小异，只要换掉ALGORITHM换成对应的值，同时做一个代码替换**SecretKey secretKey = new SecretKeySpec(key, ALGORITHM);**就可以了，此外就是密钥长度不同了。 

```java
`/**`` ``* DES          key size must be equal to 56`` ``* DESede(TripleDES) key size must be equal to 112 or 168`` ``* AES          key size must be equal to 128, 192 or 256,but 192 and 256 bits may not be available`` ``* Blowfish     key size must be multiple of 8, and can only range from 32 to 448 (inclusive)`` ``* RC2          key size must be between 40 and 1024 bits`` ``* RC4(ARCFOUR) key size must be between 40 and 1024 bits`` ``**/`
```

![各种Java加密算法](C:\Users\10224556\Desktop\Mongoose需求\Mongoose举证\安全小课题\20140412114509_299.jpg)

```java
    /**
     * 解密
     * @param data
     * @param key
     * @return
     * @throws Exception
     */
    public static byte[] decrypt(byte[] data, String key) throws Exception {
        Key k = toKey(Coder.decryptBASE64(key));
        Cipher cipher = Cipher.getInstance(“DES”);
        cipher.init(Cipher.DECRYPT_MODE, k);
        return cipher.doFinal(data);
    }
    /**
     * 加密
     * @param data
     * @param key
     * @return
     * @throws Exception
     */
    public static byte[] encrypt(byte[] data, String key) throws Exception {
        Key k = toKey(decryptBASE64(key));
        Cipher cipher = Cipher.getInstance("DES");
        cipher.init(Cipher.ENCRYPT_MODE, k);
        return cipher.doFinal(data);
    }

    /**
     * 生成随机密钥
     *
     * @return
     * @throws Exception
     */
    public static String initKey() throws Exception {
        return initKey(null);
    }

    /**
     * 生成密钥
     *
     * @param seed
     * @return
     * @throws Exception
     */
    public static String initKey(String seed) throws Exception {
        SecureRandom secureRandom = null;
        if (seed != null) {
            secureRandom = new SecureRandom(decryptBASE64(seed));
        } else {
            secureRandom = new SecureRandom();
        }
        KeyGenerator kg = KeyGenerator.getInstance(ALGORITHM);
        kg.init(secureRandom);
        SecretKey secretKey = kg.generateKey();
        return encryptBASE64(secretKey.getEncoded());
    }
```

```java
 @Test
    public void test() throws Exception {
        String inputStr = "DES";
        String key = codeEncypt.initKey();
        System.err.println("原文:\t" + inputStr);
        System.err.println("密钥:\t" + key)
        byte[] inputData = inputStr.getBytes();
        inputData = codeEncypt.encrypt(inputData, key);
        System.err.println("加密后:\t" + codeEncypt.encryptBASE64(inputData));

        byte[] outputData = codeEncypt.decrypt(inputData, key);
        String outputStr = new String(outputData);

        System.err.println("解密后:\t" + outputStr);
        assertEquals(inputStr, outputStr);
    }
```



![1573733266034](C:\Users\10224556\Desktop\Mongoose需求\Mongoose举证\安全小课题\1573733266034.png)

### 3.非对称加密

非对称加密算法需要两个密钥：[公开密钥](https://baike.baidu.com/item/公开密钥/7453570)（publickey:简称公钥）和私有密钥（privatekey:简称私钥）。公钥与私钥是一对，如果用公钥对数据进行加密，只有用对应的私钥才能解密。因为加密和解密使用的是两个不同的密钥，所以这种算法叫作非对称加密算法。

主要包含如下算法：[RSA](https://baike.baidu.com/item/RSA)、[Elgamal](https://baike.baidu.com/item/Elgamal)、背包算法、Rabin、D-H、[ECC](https://baike.baidu.com/item/ECC)（椭圆曲线加密算法）。

**RSA** 
    这种算法1978年就出现了，它是第一个既能用于数据加密也能用于数字签名的算法。它易于理解和操作，也很流行。算法的名字以发明者的名字命名：Ron Rivest, AdiShamir 和Leonard Adleman。 
    这种加密算法的特点主要是密钥的变化，上文我们看到DES只有一个密钥。相当于只有一把钥匙，如果这把钥匙丢了，数据也就不安全了。RSA同时有两把钥 匙，公钥与私钥。同时支持数字签名。数字签名的意义在于，对传输过来的数据进行校验。确保数据在传输工程中不被修改。 

**流程分析：** 

1. 甲方构建密钥对儿，将公钥公布给乙方，将私钥保留。
2. 甲方使用私钥加密数据，然后用私钥对加密后的数据签名，发送给乙方签名以及加密后的数据；乙方使用公钥、签名来验证待解密数据是否有效，如果有效使用公钥对数据解密。
3. 乙方使用公钥加密数据，向甲方发送经过加密后的数据；甲方获得加密数据，通过私钥解密。

按如上步骤给出序列图，如下： 

1. ![制作公私钥对](C:\Users\10224556\Desktop\Mongoose需求\Mongoose举证\安全小课题\20140412114510_695.jpg)

2. ![私钥加密，公钥解密](C:\Users\10224556\Desktop\Mongoose需求\Mongoose举证\安全小课题\20140412114510_316.jpg)

3. ![公钥加密，私钥解密](C:\Users\10224556\Desktop\Mongoose需求\Mongoose举证\安全小课题\20140412114510_623.jpg)

   <b>下面代码使用实例：（制作公私钥对，公钥加密，私钥解密，反之加解密流程相似。）</b>

```java
    /**
     * 初始化密钥
     *
     * @return
     * @throws Exception
     */
    public static Map<String, Object> initKey() throws Exception {
        KeyPairGenerator keyPairGen = KeyPairGenerator
                .getInstance(KEY_ALGORITHM);
        keyPairGen.initialize(1024);
        KeyPair keyPair = keyPairGen.generateKeyPair();
        // 公钥
        RSAPublicKey publicKey = (RSAPublicKey) keyPair.getPublic();
        // 私钥
        RSAPrivateKey privateKey = (RSAPrivateKey) keyPair.getPrivate();
        Map<String, Object> keyMap = new HashMap<String, Object>(2);
        keyMap.put(PUBLIC_KEY, publicKey);
        keyMap.put(PRIVATE_KEY, privateKey);
        return keyMap;
    }
	/**
     * 加密<br>
     * 用公钥加密
     * @param data
     * @param key
     * @return
     * @throws Exception
     */
    public static byte[] encryptByPublicKey(byte[] data, String key)
            throws Exception {
        // 对公钥解密
        byte[] keyBytes = decryptBASE64(key);
        // 取得公钥
        X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        Key publicKey = keyFactory.generatePublic(x509KeySpec);
        // 对数据加密
        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        return cipher.doFinal(data);
    }
	/**
     * 解密<br>
     * 用私钥解密
     * @param data
     * @param key
     * @return
     * @throws Exception
     */
    public static byte[] decryptByPrivateKey(byte[] data, String key)
            throws Exception {
        // 对密钥解密
        byte[] keyBytes = decryptBASE64(key);
        // 取得私钥
        PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(KEY_ALGORITHM);
        Key privateKey = keyFactory.generatePrivate(pkcs8KeySpec);
        // 对数据解密
        Cipher cipher = Cipher.getInstance(keyFactory.getAlgorithm());
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        return cipher.doFinal(data);
    }
```

```java
 	@Test
    public void test() throws Exception {
        System.err.println("公钥加密——私钥解密");
        String inputStr = "abc";
        byte[] data = inputStr.getBytes();

        byte[] encodedData = RSACoder.encryptByPublicKey(data, publicKey);

        byte[] decodedData = RSACoder.decryptByPrivateKey(encodedData,
                privateKey);
        String outputStr = new String(decodedData);
        System.err.println("加密前: " + inputStr + "\n\r" + "解密后: " + outputStr);
        assertEquals(inputStr, outputStr);

    }
```

![RSA公私钥对加密测试结果](C:\Users\10224556\Desktop\Mongoose需求\Mongoose举证\安全小课题\1573732233291.png)