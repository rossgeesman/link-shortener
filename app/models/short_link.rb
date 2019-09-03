class ShortLink < ApplicationRecord
  validates_presence_of :original_url
  validates :original_url, format: { with: URI.regexp }, if: Proc.new { |shortlink| shortlink.original_url.present? }
  after_update :invalidate_cache
  has_secure_token :admin_secret

  def self.find_by_short_code(short_code)
    id = short_code.to_i(36)
    Rails.cache.fetch("shortlink:#{id}") do
      find_by!(id: id, active: true)
    end
  end

  private

  def invalidate_cache
    Rails.cache.delete("shortlink:#{self.id}")
  end
end
