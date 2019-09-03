# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortLink, type: :model do
  before :each do
    # Normally I would configure this globally but for the sake of simplicity I'm doing it here
    ShortLink.destroy_all
  end

  describe '#new' do
    let(:valid_attributes) do
      {
        original_url: 'https://google.com',
        admin_secret: 'abc123'
      }
    end
    it 'should require an original_url' do
      missing_original_url = ShortLink.new(valid_attributes.merge(original_url: ''))
      expect(missing_original_url).not_to be_valid
    end
  end

  describe '#create' do
    let(:new_shortlink) do
      ShortLink.create(original_url: 'https://google.com')
    end
    it 'should not have views' do
      expect(new_shortlink.view_count).to eq(0)
    end
    it 'should be active' do
      expect(new_shortlink.active).to be_truthy
    end
    it 'should have an admin_secret' do
      expect(new_shortlink.admin_secret).to be_an_instance_of(String)
    end
  end

  describe '#find_by_short_code' do
    let(:rails_cache) { Rails.cache }
    let(:short_link) { ShortLink.create(original_url: 'https://google.com') }
    it 'should cache on first retrieval' do
      cache_key = "shortlink:#{short_link.id}"
      short_code = short_link.id.to_s(36)
      expect(rails_cache.exist?(cache_key)).to be_falsey
      ShortLink.find_by_short_code(short_code)
      expect(rails_cache.exist?(cache_key)).to be_truthy
    end

    it 'should not query database' do
      allow(ShortLink).to receive(:find_by!)
      short_code = short_link.id.to_s(36)
      ShortLink.find_by_short_code(short_code)
      ShortLink.find_by_short_code(short_code)
      expect(ShortLink).to have_received(:find_by!).exactly(1).times
    end

    it 'should not return innactive records' do
      short_link.update(active: false)
      short_code = short_link.id.to_s(36)
      expect { ShortLink.find_by_short_code(short_code) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
