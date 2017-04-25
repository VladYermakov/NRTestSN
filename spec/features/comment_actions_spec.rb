RSpec.feature 'Comment actions', :type => :feature, :js => true do
  let!(:user) { User.create email: 'user_best@gmail.com', password: '123123123' }
  let!(:other_user) { User.create email: 'other_user@gmail.com', password: 'passwd' }
  let!(:article) { Article.new title: 'hello', content: 'world!', user_id: 1 }
  let!(:comment) { Comment.new content: 'commentar', user_id: 1, article_id: 1 }
  let!(:other_comment) { Comment.new content: 'byebye universe!', user_id: 2, article_id: 1 }

  scenario 'Guest must not be able to comment articles' do
    given_a_guest_that_visit_article_page
    then_they_must_not_see_input
  end

  scenario 'User must be able to comment article' do
    given_a_user_that_visit_article_page
    then_they_must_see_input
    when_they_create_comment
    then_it_must_clear_input
    and_they_must_see_created_comment
  end

  scenario 'User must be able to edit comment' do
    given_a_user_that_visit_article_page_with_comment
    they_must_see_saved_comment
    when_they_click_edit_button
    they_must_see_comment_in_input
    when_they_edit_comment
    then_they_must_see_clear_input
    and_they_must_see_updated_comment
  end

  scenario 'User must be able to delete comment' do
    given_a_user_that_visit_article_page_with_comment
    when_they_click_delete_button
    then_they_must_not_see_comment
  end

  scenario 'User clicks button abort' do
    given_a_user_that_visit_article_page_with_comment
    when_they_click_edit_button
    and_then_click_abort_button
    then_they_must_see_clear_input
    and_they_must_see_initial_comment
  end

  scenario 'User not able to delete/edit foreign commet' do
    given_a_user_that_visit_article_page_with_two_comments
    they_must_not_be_able_to_delete_or_edit_foreign_comment
  end

  def given_a_guest_that_visit_article_page
    article.save!
    visit "/articles/#{article.id}"
  end

  def then_they_must_not_see_input
    expect { find('.create-comment') }.to raise_error Capybara::ElementNotFound
  end

  def given_a_user_that_visit_article_page
    login_as user, :scope => :user
    given_a_guest_that_visit_article_page
  end

  def given_a_user_that_visit_article_page_with_comment
    login_as user, :scope => :user
    article.save!
    comment.save!
    visit "/articles/#{article.id}"
  end

  def then_they_must_see_input
    expect { find('.create-comment') }.to_not raise_error
  end

  def when_they_create_comment
    find('.create-comment .comment-content').base.send_keys 'Comment'
    click_button 'Post'
  end

  def then_it_must_clear_input
    expect(find('.create-comment .comment-content').text).to eq ''
  end

  def and_they_must_see_created_comment
    expect(find('#content-1').text).to eq 'Comment'
  end

  def they_must_see_saved_comment
    expect(find('#content-1').text).to eq comment.content
  end

  def when_they_click_edit_button
    find("#icon-#{comment.id}").click
    find("#edit-comment-#{comment.id}").click
  end

  def they_must_see_comment_in_input
    expect(find('.create-comment .comment-content').text).to eq comment.content
  end

  def when_they_edit_comment
    find('.create-comment .comment-content').base.send_keys 'new_'
    click_button 'Update'
  end

  def then_they_must_see_clear_input
    expect(find('.create-comment .comment-content').text).to eq ''
  end

  def and_they_must_see_updated_comment
    expect(find('#content-1').text).to eq "new_#{comment.content}"
  end

  def when_they_click_delete_button
    find("#icon-#{comment.id}").click
    find("#delete-comment-#{comment.id}").click
  end

  def then_they_must_not_see_comment
    expect(page).to_not have_text comment.content
  end

  def and_then_click_abort_button
    find('[name="abort"]').click
  end

  def and_they_must_see_initial_comment
    expect(find('#content-1').text).to eq comment.content
  end

  def given_a_user_that_visit_article_page_with_two_comments
    article.save!
    comment.save!
    other_comment.save!

    login_as user, :scope => :user
    visit '/articles/1'
  end

  def they_must_not_be_able_to_delete_or_edit_foreign_comment
    expect { find("#icon-#{other_comment.id}") }.to raise_error Capybara::ElementNotFound
  end
end
