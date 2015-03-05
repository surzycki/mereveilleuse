RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  factory_girl_results = {}
  config.before(:suite) do
    ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
      factory_name = payload[:name]
      strategy_name = payload[:strategy]
      factory_girl_results[factory_name] ||= {}
      factory_girl_results[factory_name][strategy_name] ||= 0
      factory_girl_results[factory_name][strategy_name] += 1
    end
  end
  
  config.after(:suite) do
    require 'hirb'
    extend Hirb::Console

    x = factory_girl_results.collect do |k,v| 
      v[:name] = k
      OpenStruct.new v
    end

    totals = OpenStruct.new(name: 'TOTALS')
    [:create, :build, :build_stubbed, :attributes_for].collect do |key|
      value = x.inject(0){|sum,e| sum += (e.send(key)).to_i }
       totals[key] = value
    end    

    all = x + [totals]

    puts "\n"

    table [*all], :fields=>[:name, :create, :build, :build_stubbed, :attributes_for]
  end
end

