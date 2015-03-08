#class SignedRequest
#  attr_reader :signed_request, :oauth_token, :algorithm, :expires, :issued_at, :country,
#              :locale, :user_id, :signature, :expected_signature
#
#  def initialize(signed_request)
#    @signed_request = signed_request
#    decode
#  end
#
#  def valid_signature?
#    @signature == @expected_signature
#  end
#
#  private 
#  def decode
#    encoded_signature, payload = signed_request.split('.')
#    
#    @signature = base64_url_decode encoded_signature
#    
#    set_attributes(base64_url_decode payload)
#    set_expected_signature payload 
#  rescue Exception => e
#    # catch
#  end
#
#  def set_attributes(json_string)
#    json = JSON.parse(json_string).with_indifferent_access
#
#    @algorithm    = json[:algorithm]
#    @expires      = json[:expires]
#    @issued_at    = json[:issued_at]
#    @oauth_token  = json[:oauth_token]
#    @user_id      = json[:user_id]
#
#    if json[:user]
#      @country = json[:user][:country]
#      @locale  = json[:user][:locale]
#    end
#  end
#
#  def set_expected_signature(data)
#    digest = OpenSSL::Digest.new('sha256')
#    key    = ENV['FACEBOOK_SECRET']
#
#    @expected_signature = OpenSSL::HMAC.digest(digest, key, data)
#  end
#
#  def base64_url_decode(str)
#    str += '=' * (4 - str.length.modulo(4))
#    Base64.decode64(str.tr('-_','+/'))
#  end
#end#