module FormattingHelper
  def format_french_phone_number(phone)
    return if phone.nil?
       
    phone.unpack('A2A2A2A2A2').join(' ')
  end
end
