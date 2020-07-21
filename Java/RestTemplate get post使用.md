## RestTemplate get post使用

### 1. getForObject

```java
	/**
	* Client
	* 1.get 方式传参   xx:8080/req?key1={val}&key2={val2}   @RequestParam String val
	* 2.get 方式可变请求 xx:8080/req/{1}/{2}   {key1}/{key2} @PathVariable String aa
	*/
	@ResponseBody
    @GetMapping("get")
    public String getMethod(){
        String url="http://127.0.0.1:18090/rest/get?key1={key1}&key2={key}";
        Map<String,String> map = new HashMap();
        map.put("key1","aa");
        map.put("key","bb");
        String forObject = restTemplate.getForObject(url, String.class, map);
        return forObject;
    }
    @ResponseBody
    @GetMapping("get2")
    public String getMethod1(){
        String url="http://127.0.0.1:18090/rest/get2/{key1}/{key}";
        Map<String,String> map = new HashMap();
        map.put("key1","aa");
        map.put("key","bb");
        String forObject = restTemplate.getForObject(url, String.class, map);
        return forObject;
    }
```

```java
    /**
    * Server
    */
 @ResponseBody
    @GetMapping("get")
    public String xx(@RequestParam("key1") String val1,@RequestParam("key2") String val2)	{
        String val = val1 +val2 +"==";
        return val;
    }

    @ResponseBody
    @GetMapping("get2/{aa}/{bb}")
    public String xxy(@PathVariable("aa") String val1,@PathVariable("bb") String val2){
        String val = val1 +val2 +"==";
        return val;
    }
```

### 2.postForEntity

```java
	/**
	* Client post请求 json格式传输 
	*/
	@ResponseBody
    @RequestMapping("hh")
    public JSONObject getRequest(){
        String url="http://127.0.0.1:18090/rest/requestWS";
        HttpHeaders headers = new HttpHeaders();
        //定义请求参数类型，这里用json所以是MediaType.APPLICATION_JSON
        headers.setContentType(MediaType.APPLICATION_JSON);
        //RestTemplate带参传的时候要用HttpEntity<?>对象传递
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("JobID", "Project01_Tab1_Sheet1_GRID1");
        JSONArray ja = new JSONArray();
        JSONObject js = new JSONObject();
        js.put("Name", "TEXTEDITOR2");
        js.put("Type", "1");
        js.put("Value", 2000);
        ja.add(js);
        jsonObject.put("Parameter", ja);
        HttpEntity request = new HttpEntity(jsonObject, headers);

        ResponseEntity<String> entity = restTemplate.postForEntity(url, request, String.class);
        //获取3方接口返回的数据通过entity.getBody();它返回的是一个字符串；
        String body = entity.getBody();
        //然后把str转换成JSON再通过getJSONObject()方法获取到里面的result对象，因为我想要的数据都在result里面
        //下面的strToJson只是一个str转JSON的一个共用方法；
        JSONObject json = JSONObject.parseObject(body);
        return json;
    }
```

```java
	/**
	* Server @RequestBody JSONObject  接收
	*/
	@ResponseBody
    @PostMapping("requestWS")
    public String provider(@RequestBody JSONObject jsonParam){
        List<ArrayList<String>> executeRes = webServiceJobExecutor.executeJob(jsonParam);
        JSONObject result = new JSONObject();
        if(executeRes == null){
            result.put("msg", "error");
            result.put("data", "");
        }else {
            result.put("msg", "ok");
            result.put("data", executeRes.toString());
        }
        return result.toJSONString();
    }
```

