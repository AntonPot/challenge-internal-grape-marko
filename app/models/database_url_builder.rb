class DatabaseUrlBuilder
  def self.build
    "postgres://#{APP_CONFIG.fetch(:username)}:#{APP_CONFIG.fetch(:password)}@#{APP_CONFIG.fetch(:host)}:#{APP_CONFIG.fetch(:port)}/#{APP_CONFIG.fetch(:database)}?encoding=#{APP_CONFIG.fetch(:encoding)}"
  end
end
