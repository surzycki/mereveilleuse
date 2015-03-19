class NullOccupation
  def name
    I18n.t('not_available')
  end

  def experience
    0
  end

  def profession_id
    0
  end
end