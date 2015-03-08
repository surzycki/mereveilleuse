class Authentication
  attr_reader :repository, :listener

  def initialize(listener)
    #@repository = repository
    @listener   = listener
  end

  def with(args)
    facebook_id = args.fetch 'id', ''

    begin
      account = User.find_or_create_by(facebook_id: facebook_id)
  
      account.update(
        firstname: args.fetch 'first_name', 'unknown',
        lastname:  args.fetch 'last_name',  'unknown',
        email:     args.fetch 'email',      'unknown'
      )

      @listener.on_authentication_success account

      if account.registered?
        @listener.on_login_success account
      else
        @listener.on_registration_success 
      end
    
    rescue Exception => error
      @listener.on_authentication_fail error
    end
  end
end