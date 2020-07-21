class NewUUID
  def self.call
    SecureRandom.uuid
  end
end