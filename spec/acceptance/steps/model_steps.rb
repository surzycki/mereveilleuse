module ModelSteps
  step 'the :model has :value for the :attribute' do |model, value, attribute|
    model = get_model_instance model
    instance.update(Hash[attribute,value])
  end

  step 'the :model :whether_to have :expected_value for :attribute' do |model, positive, expected_value, attribute|
    expectation = positive ? :to : :not_to

    model = get_model_instance model

    actual_value = model.send(attribute).to_s

    expect(expected_value).send expectation, eq(actual_value)
  end  
end

RSpec.configure do |config| 
  config.include ModelSteps
end