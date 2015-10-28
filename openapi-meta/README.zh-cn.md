* 版本信息描述文件      
 * 描述：API分为产品、版本、API三级，在每个版本的目录下都有个版本第一文件，命名为：Version-Info.json，此文件包含了API版本的描述信息。        
 * 属性：    
     * apiStyle : API的风格，生成SDK时有用，不同风格的API签名方法不同，apiStyle按版本指定，同一版本的API类型相同；    
     * apis : 此版本下包含的所有API的名称；     
     * name : 版本名称；    
     * product : 产品名称。    
     * pattern：ROA类型的API有此参数；    

* API 描述文件
 * 描述：API描述文件按文件目录产品、版本、API进行组织，包含了API的描述信息；
 * 属性：
     * isvProtocol:
     * method ：此API支持的请求方法；
     * protocol : 此API支持的协议；
     * product : 产品
     * version ：API版本；
     * name : API名称；
     * parameters ：API入参列表
     * required ：是否必填参数；
     * tagName ：请求参数；
     * tagPosition ：参数位置，可选值：
           * Query ：URL传参或POST请求通过Body传参的参数；
           * Path ：对于ROA类型的API定义在pattern里的参数
           * Domain ：定义在域名里的参数；
           * Header ：通过header传参的参数；
     * type : 参数类型，支持 Long、Integer、Float、Double、String等类型；
     * valueSwitch : 如果valueSwitch不为空说明此参数为枚举值，可枚举的值即为valueSwitch指定的值；
     * resultMapping ：访问结果定义信息，包含返回参数及结构；
           * arrays ：表明是列表结构；
           * list : 用于简单类型,等同于 List&#60;String&#62;；
           * itemName : arrays中item的类型名；
           * members ：结构体的属性信息；
           * tagName : 属性名；
     * type ：属性的类型。