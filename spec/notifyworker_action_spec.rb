describe Fastlane::Actions::NotifyworkerAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The notifyworker plugin is working!")

      Fastlane::Actions::NotifyworkerAction.run(nil)
    end
  end
end
