# How to use console?

After donwload entire code base, run ```bundle install``` under the working copy. You need to export your key id and key secret by environment variables

```bash
export KEY_ID=7jdfadfdsafadas
export KEY_SECRET=4qX6adfasfdasfadsfasfas
```

Then you could run ```bin/console`` , it will start a Pry session with necessary instruction to make any API call.

For example:

```ruby
require 'aliyun/openapi/ecs'
Aliyun::Openapi::Core::ApiDSL.client.ecs(version:'2014-05-26').describe_regions do |response|
  # require 'pry'; binding.pry
  p response
end
```

