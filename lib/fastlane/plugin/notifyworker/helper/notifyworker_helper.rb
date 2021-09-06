require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class NotifyworkerHelper
      # class methods that you define here become available in your action
      # as `Helper::NotifyworkerHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the notifyworker plugin helper!")
      end
    end
  end
end
