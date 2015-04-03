describe SlackNotifierJob, focus: true do 
  subject { SlackNotifierJob.new }
  
  let(:message)  { 'hello world' }
  let(:notifier) { spy('slack notifier')}

  describe '#perform' do
    context 'success' do
      before do 
        allow(Slack::Notifier).to receive(:new).and_return notifier
        
        subject.perform message
      end

      it 'sends message' do
        expect(notifier).to have_received(:ping)
          .with message, icon_url: AppFacebook.config.slack_icon_url
      end

      it 'creates notifier' do
        expect(Slack::Notifier).to have_received(:new)
          .with AppFacebook.config.slack_webhook_url, channel: AppFacebook.config.slack_channel
      end
    end

    context 'exception' do
      before do 
        allow(Slack::Notifier).to receive(:new).and_raise :error
        allow(TrackError).to receive(:new)
        
        subject.perform message
      end

      it 'does NOT send message' do
        expect(notifier).to_not have_received(:ping)
      end

      it 'tracks error' do
        expect(TrackError).to have_received(:new)
      end
    end
  end  
end