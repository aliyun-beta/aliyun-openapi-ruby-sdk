# aliyun-openapi

[![Join the chat at https://gitter.im/shruby/aliyun-openapi](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/shruby/aliyun-openapi?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/aliyun-beta/aliyun-openapi-ruby-sdk.svg)](https://travis-ci.org/aliyun-beta/aliyun-openapi-ruby-sdk)
[![Coverage Status](https://coveralls.io/repos/aliyun-beta/aliyun-openapi-ruby-sdk/badge.svg?branch=master&service=github)](https://coveralls.io/github/aliyun-beta/aliyun-openapi-ruby-sdk?branch=master)

# How does it work?

Essentially ```aliyun-openapi``` is DSL definition + code generator. It generate the code based on openapi-meta JSON files.

# How to use this code?

Before everything, make sure you run ```rake codegen:generate_code``` to build generated code and test!

## Step 1 : Configuration

You need to configure the openapi before using it.

```ruby
Aliyun::Openapi.configure do |config|
  config.ssl_required = true
  config.access_key_id = YOU_KEY_ID
  config.access_key_secret = YOUR_KEY_SECRET
  config.region = 'cn-hangzhou'
end
```


## Step 2 : 
require necessary lib files
```ruby
require 'aliyun/openapi/all'
```

if you want to call particular product, just go with
```ruby
require 'aliyun/openapi/ecs'
```


## Step 3 : Call API by DSL like this

Here is the example:

```ruby
Aliyun::Openapi::Client.ecs(version:'2014-05-26').describe_regions do |response|
  p response
end
```

The basic calling name convention is :
```ruby
Aliyun::Openapi::Client.[product](version: [version]).[api_end_point]([param_key]: [param_value] ...) do |resposne|
# response is a Faraday response object
end
```
