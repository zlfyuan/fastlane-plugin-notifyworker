require 'fastlane/action'
require_relative '../helper/notifyworker_helper'
require 'faraday'
require 'json'

module Fastlane
   module Actions
      class NotifyworkerAction < Action
         def self.run(params)
            UI.message("The notifyworker plugin is working!")

            webhook = params[:webhook]
            api_key = params[:api_key]
            app_key = params[:app_key]
            updateDes = params[:updateDes]
            platform = params[:platform]
            atAll = params[:atAll]

            if platform.nil?
               platform = "DingTalk"
            end

            if updateDes.nil?
               updateDes = "app 更新了"
            end

            pgy_info_url = "https://www.pgyer.com/apiv2/app/view"

            conn_options = {
               request: {
                  timeout:       1000,
                  open_timeout:  300
               }
            }

            _faraday = Faraday.new(nil, conn_options) do |c|
               c.request :multipart
               c.request :url_encoded
               c.response :json, content_type: /\bjson$/
               c.adapter :net_http
            end

            params = {
               '_api_key' => api_key,
               'appKey' => app_key,
            }

            UI.message "get app info ..."

            response = _faraday.post pgy_info_url, params
            body = response.body

            # UI.message "#{body}"

            if body["code"] != 0
               UI.user_error!("Notifyworker Plugin Error: #{body["message"]}")
            end

            UI.message "Get app info success ..."
            appInfo = body["data"]
            sizeStr = appInfo['buildFileSize']
            _size = (sizeStr.to_i) / 1024 / 1024
            version = "版本：#{appInfo['buildVersion']} (build #{appInfo['buildBuildVersion']})"
            size = "大小：#{_size} MB"
            update_time = "更新时间 ：#{appInfo['buildUpdated']}"
            open_url_path = "https://www.pgyer.com/#{appInfo['buildShortcutUrl']}"
            download_url_path = open_url_path
            picUrl = appInfo['buildQRCodeURL']
            title = "请点击我测试\n#{appInfo["buildName"]}"

            _updateDes = "此次更新内容：#{updateDes}"

            if platform == "DingTalk"

               _news = {
                  "msgtype" => "markdown",
                  "markdown" => {
                     "title" => "安装测试版",
                     "text" => "# #{appInfo["buildName"]} \n ### #{version} \n ### #{size} \n ### #{update_time} \n ### #{_updateDes} \n > ![screenshot](#{picUrl}) \n\n > [直接下载](#{download_url_path}) \n"
                  },
                  "at": {
                     "atMobiles" => [
                     ],
                     "atUserIds" => [
                     ],
                     "isAtAll" => atAll
                  },
               }

               dingding_faraday = Faraday.new(nil, conn_options) do |c|
                  c.headers['Content-Type'] = 'application/json'
                  c.request :multipart
                  c.request :url_encoded
                  c.response :json, content_type: /\bjson$/
                  c.adapter :net_http
               end

               webhook_dingding_response = dingding_faraday.post webhook, _news.to_json
               webhook_dingding_body = webhook_dingding_response.body
               if webhook_dingding_body['errcode'] != 0
                  # UI.user_error!("#{webhook_dingding_body}")
                  UI.user_error!("Notifyworker Plugin Error: #{webhook_dingding_body["errmsg"]}")
               end

               UI.message "Notify success, look DingTalk"
            else #Wechat
               UI.user_error!("Notifyworker Plugin Error: WeChatAPI has error, Please wait")

               _new = {
                  "msgtype" => "markdown",
                  "markdown" => {
                     "content" => "# #{appInfo["buildName"]}\\n ### #{version} \\n ### #{size} \\n ### #{update_time} \\n ### #{_updateDes} \\n > [直接下载](#{download_url_path}) \\n"
                  }
               }
               UI.message "_new #{_new}"

               weChat_faraday = Faraday.new(nil, conn_options) do |c|
                  c.headers['Content-Type'] = 'application/json'
                  c.request :multipart
                  c.request :url_encoded
                  c.response :json, content_type: /\bjson$/
                  c.adapter :net_http
               end

               weChat_dingding_response = weChat_faraday.post webhook, _news.to_json
               weChat_dingding_body = weChat_dingding_response.body
               if weChat_dingding_response['errcode'] != 0
                  UI.user_error!("#{weChat_dingding_response}")
                  UI.user_error!("noti_person Plugin Error: #{weChat_dingding_response["errmsg"]}")
               end
               UI.message "Notify success, look WeChat"
            end
         end

         def self.description
            "Notify some worker App's status"
         end

         def self.authors
            ["zlfyuan"]
         end

         def self.return_value
            # If your method provides a return value, you can describe here what it does
         end

         def self.details
            # Optional:
            "Let some worker know the status of the app, for example, tell worker in the company that the app is updated and the app can be tested"
         end

         def self.available_options
            [
               FastlaneCore::ConfigItem.new(key: :api_key,
               env_name: "PGYER_API_KEY",
               description: "Api_key of pgy platform",
               optional: false,
               type: String),
               FastlaneCore::ConfigItem.new(key: :app_key,
               env_name: "PGYER_APP_KEY",
               description: "App_key of pgy platform",
               optional: false,
               type: String),
               FastlaneCore::ConfigItem.new(key: :webhook,
               env_name: "WEB_HOOK",
               description: "webhook in your using platform",
               optional: false,
               type: String),
               FastlaneCore::ConfigItem.new(key: :platform,
               env_name: "PLATFORM",
               description: "The platform to which the webhook belongs, defalult DingTalk",
               optional: true,
               type: String),
               FastlaneCore::ConfigItem.new(key: :updateDes,
               env_name: "UPDATEDES",
               description: "this a description of App's update",
               optional: true,
               type: String),
               FastlaneCore::ConfigItem.new(key: :atAll,
                env_name: "ATALL",
                description: "Whether @everyone？",
                optional: true,
                type: String),
            ]
         end

         def self.is_supported?(platform)
            # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
            # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
            #
            [:ios, :mac, :android].include?(platform)
            true
         end
      end
   end
end
