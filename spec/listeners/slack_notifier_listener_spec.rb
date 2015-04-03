describe SlackNotifierListener do
  let(:subject)  { SlackNotifierListener.new }
  
  before { allow(SlackNotifierJob).to receive(:perform_later) }

  describe '#initialize' do
    it 'initializes' do
      expect { SlackNotifierListener.new }.to_not raise_error
    end
  end 

  describe '#signup' do
    #it 'queues practitioner geocode job' do
    #  expect(GeocodePractitionerJob).to have_received(:perform_later)
    #end
  end
end