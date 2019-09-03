require 'rails_helper'

RSpec.describe ShortLinksController, type: :controller do
  before :each do
    # Normally I would configure this globally but for the sake of simplicity I'm doing it here
    ShortLink.destroy_all
  end
  describe 'show' do
    let(:code) do
      link = ShortLink.create(original_url: 'https://google.com')
      link.id.to_s(36)
    end
    it 'should redirect to the original_url' do
      process :show, method: :get, params: {short_code: code}
      expect(response).to redirect_to('https://google.com')
    end
    it 'should return a 301' do
      process :show, method: :get, params: {short_code: code}
      expect(response.status).to be(301)
    end
    it 'should return a 404 if the link is innactive' do
      short_link = ShortLink.find_by_short_code(code)
      short_link.update(active: false)
      process :show, method: :get, params: {short_code: code}
      expect(response.status).to be(404)
    end
  end
  describe 'create' do
    let(:url) { 'https://mycoolurl.com' }
    it 'should create a new ShortLink' do
      assert(ShortLink.count == 0)
      process :create, method: :post, params: {short_link: {original_url: url}}
      shortlink = ShortLink.first
      expect(shortlink.original_url).to eq(url)
    end
  end
  describe 'edit' do
    let(:shortlink) { ShortLink.create(original_url: 'https://google.com') }
    it 'should render edit with admin_secret' do
      process :edit, method: :get, params: {admin_secret: shortlink.admin_secret}
      expect(response.status).to eq(200)
      expect(response).to render_template(:edit)
    end
    it 'should respond with 404 with incorrect secret' do
      process :edit, method: :get, params: {admin_secret: 'notarealadminsecret'}
      expect(response.status).to eq(404)
    end
  end
end
