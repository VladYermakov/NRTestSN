RSpec.feature 'Following', :type => :feature, :js => true do

  5.times do |i|
    let!(:"user_#{i + 1}") { FactoryGirl.create :user }
    let!(:"article_#{i + 1}") do
      Article.new title: "u#{i + 1}a", content: "article of #{i + 1}th user",
                  user_id: send(:"user_#{i + 1}").id
    end
  end

  let!(:comment_3) { Comment.new content: "comment 3", user_id: user_3.id,
                                 article_id: article_3.id }

  let!(:comment_1) { Comment.new content: "comment 1", user_id: user_1.id,
                                 article_id: article_1.id }

  scenario 'User following other user' do
    given_a_user_that_visit_user_page
    then_they_must_see_user_info
    and_they_must_see_follow_button
    when_they_click_follow
    then_button_must_be_unfollow
    and_the_followers_number_must_be_one
    and_when_they_click_unfollow
    then_button_must_be_follow_again
    and_the_followers_number_must_be_zero
  end

  scenario 'User see articles of other user' do
    given_a_user_that_visit_user_page_when_articles_created
    then_they_must_see_other_user_article
    and_they_must_not_see_own_article
  end

  scenario 'User see followed users of other user' do
    given_other_user_that_followed_three_users
    and_user_that_visit_user_page
    then_they_must_see_two_followed
    when_they_go_to_following_page
    they_must_see_both_followed_users
    and_they_must_see_their_articles
    and_they_must_see_comment_of_one_user
  end

  scenario 'User see followers of other user' do
    given_other_user_that_followed_three_users
    and_user_that_visit_user_page
    then_they_must_see_one_followers_count
    when_they_go_to_followers_page
    then_they_must_see_one_follower
    and_they_must_see_their_article
    and_they_must_see_their_comment
  end

  scenario 'User see no users if other user no following' do
    given_a_user_that_visit_user_page
    and_then_click_followers_link
    then_they_must_see_no_users
  end

  def given_a_user_that_visit_user_page
    login_as user_1, :scope => :user
    visit "/users/2"
    #wait_for_ajax
  end

  def given_a_user_that_visit_user_page_when_articles_created
    article_1.save!
    article_2.save!
    login_as user_1, :scope => :user
    visit '/users/2'
  end

  def then_they_must_see_user_info
    expect(page).to have_text user_2.email
  end

  def and_they_must_see_follow_button
    expect { find('.user-follow-unfollow') }.to_not raise_error

    expect(find('.user-follow-unfollow button').text).to eq 'Follow'
  end

  def then_they_must_see_other_user_article
    expect(page).to have_text article_2.title
    expect(page).to have_text article_2.content
  end

  def and_they_must_not_see_own_article
    expect(page).to_not have_text article_1.title
    expect(page).to_not have_text article_1.content
  end

  def when_they_click_follow
    click_button 'Follow'
  end

  def then_button_must_be_unfollow
    expect(find('.user-follow-unfollow button').text).to eq 'Unfollow'
  end

  def and_when_they_click_unfollow
    click_button 'Unfollow'
  end

  def then_button_must_be_follow_again
    expect(find('.user-follow-unfollow button').text).to eq 'Follow'
  end

  def and_the_followers_number_must_be_one
    expect(find('.user-followers a').text).to eq '1'
  end

  def and_the_followers_number_must_be_zero
    expect(find('.user-followers a').text).to eq '0'
  end

  def given_other_user_that_followed_three_users
    user_2.follow user_3
    user_2.follow user_4
    user_2.follow user_5
    user_1.follow user_2
    4.times do |i|
      send(:"article_#{i + 1}").save!
    end
    comment_3.article_id = article_3.id
    comment_1.article_id = article_1.id
    comment_3.save!
    comment_1.save!
  end

  def and_user_that_visit_user_page
    login_as user_1, :scope => :user
    visit "/users/#{user_2.id}"
  end

  def then_they_must_see_two_followed
    expect(find('.user-following a').text).to eq '3'
  end

  def then_they_must_see_one_followers_count
    expect(find('.user-followers a').text).to eq '1'
  end

  def when_they_go_to_following_page
    find('.user-following a').click
  end

  def when_they_go_to_followers_page
    find('.user-followers a').click
  end

  def they_must_see_both_followed_users
    expect{ find('#no-users') }.to raise_error Capybara::ElementNotFound

    expect{ find("#user-#{user_3.id}") }.to_not raise_error
    expect{ find("#user-#{user_4.id}") }.to_not raise_error

    expect(find("#user-#{user_3.id} .user-email a").text).to eq user_3.email
    expect(find("#user-#{user_4.id} .user-email a").text).to eq user_4.email
  end

  def then_they_must_see_one_follower
    expect{ find('#no-users') }.to raise_error Capybara::ElementNotFound

    expect{ find("#user-#{user_1.id}") }.to_not raise_error

    expect(find("#user-#{user_1.id} .user-email a").text).to eq user_1.email
  end

  def and_they_must_see_their_articles
    expect{ find("#user-#{user_3.id} .article") }.to_not raise_error
    expect{ find("#user-#{user_4.id} .article") }.to_not raise_error
    expect{ find("#user-#{user_5.id} .article") }.to_not raise_error

    expect(find("#user-#{user_3.id} .article .article-title a").text).to eq article_3.title
    expect(find("#user-#{user_3.id} .article .article-content").text).to eq article_3.content

    expect(find("#user-#{user_4.id} .article .article-title a").text).to eq article_4.title
    expect(find("#user-#{user_4.id} .article .article-content").text).to eq article_4.content

    expect{ find("#user-#{user_5.id} .no-article") }.to_not raise_error
  end

  def and_they_must_see_their_article
    expect{ find("#user-#{user_1.id} .article") }.to_not raise_error

    expect(find("#user-#{user_1.id} .article .article-title a").text).to eq article_1.title
    expect(find("#user-#{user_1.id} .article .article-content").text).to eq article_1.content
  end

  def and_they_must_see_comment_of_one_user
    expect{ find("#user-#{user_3.id} .article .comment") }.to_not raise_error
    expect{ find("#user-#{user_4.id} .article .comment") }.to raise_error Capybara::ElementNotFound

    expect(find("#user-#{user_3.id} .article .comment .comment-content").text).to eq comment_3.content
  end

  def and_they_must_see_their_comment
    expect{ find("#user-#{user_1.id} .article .comment") }.to_not raise_error

    expect(find("#user-#{user_1.id} .article .comment .comment-content").text).to eq comment_1.content
  end

  def and_then_click_followers_link
    find('.user-followers a').click
  end

  def then_they_must_see_no_users
    expect{ find('#no-users') }.to_not raise_error
  end
end
