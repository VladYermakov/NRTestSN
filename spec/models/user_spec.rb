require 'rails_helper'

RSpec.describe User do
  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  describe 'articles assosiations' do

    before { puts user }

    if 'should be saved'
      its(:id) { should_not be_nil }
    end

  end

  describe 'comment assosiations' do
  end

end
