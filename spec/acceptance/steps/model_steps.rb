module ModelSteps
  step 'the :model has :value for the :attribute' do |model, value, attribute|
    model    = model.capitalize.constantize
    instance = model.first
    instance.update(Hash[attribute,value])
  end
end

RSpec.configure do |config| 
  config.include ModelSteps
end