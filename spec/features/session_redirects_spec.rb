RSpec.feature 'Session redirects', :type => :feature, :js => true do
  let!(:user) do
    User.create email: 'user@site.com',
                password: 'very_strong_password'
  end

  scenario 'Guest tried to visit feed page' do
    given_a_guest_that_visit_feed
    then_page_must_redirect_to_home
  end

  scenario 'Signed user tried to visit home page' do
    given_a_user_that_visit_home
    then_page_must_redirect_to_feed
  end

  def given_a_guest_that_visit_feed
    visit '/feed'
  end

  def given_a_user_that_visit_home
    login_as user, :scope => :user
    visit '/'
  end

  def then_page_must_redirect_to_home
    expect(page.current_path).to eq '/'
  end

  def then_page_must_redirect_to_feed
    expect(page.current_path).to eq '/feed'
  end
end
