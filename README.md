<!--
 * @Author: zluof
 * @Date: 2021-09-06 16:40:13
 * @LastEditTime: 2021-09-13 14:19:34
 * @LastEditors: zluof
 * @Description: 
 * @FilePath: /fastlane-plugin-notifyworker/README.md
-->
# notifyworker plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-notifyworker)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-notifyworker`, add it to your project by running:

```bash
fastlane add_plugin notifyworker
```

```ruby
notifyworker(
    webhook = ""    #str (required paramter)
    api_key = ""    #str (required paramter)
    app_key = ""    #str (required paramter)
    updateDes = "" #str (optional paramter)
    platform = ""  #str (optional paramter(DingTalk,WeChat) default: dingTalk )
    atAll = ""  #bool (optional paramter)
)
```
## About notifyworker

Notify some worker App's status

**Note to author:** Add a more detailed description about this plugin here. If your plugin contains multiple actions, make sure to mention them here.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)
## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
