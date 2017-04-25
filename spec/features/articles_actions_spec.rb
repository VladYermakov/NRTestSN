RSpec.feature 'Article actions', :type => :feature, :js => true do
  let!(:user) { User.create email: 'user_best@gmail.com',
                            password: 'very_strong_password' }
  let!(:other_user) { User.create email: 'other_user@gmail.com',
                            password: 'not_so_very_strong_password' }
  let!(:last_user) { User.create email: 'last_user@gmail.com',
                            password: 'passwd' }
  let!(:article) { Article.new title: 'Article first',
                            content: 'Content first', user_id: user.id }
  let!(:other_article) { Article.new title: 'Article last',
                            content: 'Some very original content', user_id: other_user.id,
                            attachment_type: 'Article', attachment_id: 1}
  let!(:last_article) { Article.new title: 'Article sure last',
                            content: 'Again content', user_id: last_user.id}
  let!(:comment) { Comment.new content: 'Commentaire',
                            user_id: user.id, article_id: user.id }

  before do
    user.follow other_user
  end

  scenario 'User create a new article without attachment' do
    given_a_user_that_visit_feed
    when_they_fill_in_inputs_and_submit_article
    then_it_must_clear_inputs
    and_it_must_add_article_to_page
  end

  scenario 'User delete the article' do
    given_a_user_that_visit_feed_with_article
    they_must_see_saved_article
    when_they_click_delete_article
    then_they_must_not_see_article
  end

  scenario 'User edit the article' do
    given_a_user_that_visit_feed_with_article
    they_must_see_saved_article
    when_they_click_edit_article
    then_they_must_see_data_in_inputs
    when_they_changing_inputs
    then_it_must_clear_inputs
    and_they_must_see_updated_article
  end

  scenario 'User edit article attachment' do
    given_an_other_user_that_visit_feed_with_articles_and_comment
    when_they_click_edit_second_article
    and_choose_attachment_comment
    then_they_must_see_chosen_comment_in_input
    when_they_update_article
    then_they_must_see_other_article_with_attachment_comment
  end

  scenario 'User abort editing the article' do
    given_a_user_that_visit_feed_with_article
    when_they_click_edit_article
    and_then_click_abort_button
    then_it_must_clear_inputs
    and_they_must_see_initial_article
  end

  scenario 'User unable to delete/edit foreign article' do
    given_a_user_that_visit_feed_with_articles
    they_must_not_be_able_to_delete_or_edit_foreign_article
  end

  scenario 'User create article with article attachment' do
    given_a_user_that_visit_feed_with_article
    when_they_fill_in_inputs_and_choose_article
    then_they_must_see_chosen_article_in_input
    when_they_submit_article
    then_they_must_see_article_with_attachment_article
  end

  scenario 'User create article with comment attachment' do
    given_a_user_that_visit_feed_with_article_and_comment
    when_they_fill_in_inputs_and_choose_comment
    then_they_must_see_chosen_comment_in_input
    when_they_submit_article
    then_they_must_see_article_with_attachment_comment
  end

  scenario 'User create article with file attachment' do
    given_a_user_that_visit_feed
    when_they_fill_in_inputs_and_choose_file
    then_they_must_see_chosen_file_in_input
    when_they_submit_article
    then_they_must_see_article_with_attachment_file
  end

  scenario 'User update article with attached file' do
    given_a_user_that_visit_feed
    when_they_fill_in_inputs_and_choose_file
    when_then_submit_article
    and_then_click_edit_button
    then_they_must_see_data_and_file_in_inputs
  end

  scenario 'User see only followed users articles' do
    given_a_user_that_visit_feed_with_articles
    they_must_see_two_articles
    and_they_must_not_see_last_article
  end

  def given_a_user_that_visit_feed
    login_as user, :scope => :user
    visit '/feed'
  end

  def when_they_fill_in_inputs_and_submit_article
    find('.create-article .article-title').base.send_keys('Title')
    find('.create-article .article-content').base.send_keys('Content')

    click_button 'Post'
  end

  def then_it_must_clear_inputs
    expect(find('.create-article .article-title').text).to eq ''
    expect(find('.create-article .article-content').text).to eq ''
  end

  def and_it_must_add_article_to_page
    expect(find('#title-1').text).to eq 'Title'
    expect(find('#content-1').text).to eq 'Content'
  end

  def given_a_user_that_visit_feed_with_article
    article.save!
    given_a_user_that_visit_feed
  end

  def they_must_see_saved_article
    expect(page).to have_text article.title
    expect(page).to have_text article.content
  end

  def when_they_click_delete_article
    find(".article .menu i#icon-#{article.id}").click
    find(".article .menu a#delete-article-#{article.id}").click
  end

  def then_they_must_not_see_article
    expect(page).to_not have_text article.title
    expect(page).to_not have_text article.content
  end

  def when_they_click_edit_article
    find(".article .menu i#icon-#{article.id}").click
    find(".article .menu a#edit-article-#{article.id}").click
  end

  def and_then_click_abort_button
    find('[name="abort"]').click
  end

  def then_they_must_see_data_in_inputs
    expect(find(".create-article .article-title").text).to eq article.title
    expect(find(".create-article .article-content").text).to eq article.content
  end

  def when_they_changing_inputs
    find('.create-article .article-title').base.send_keys('new_')
    find('.create-article .article-content').base.send_keys('new_')

    click_button 'Update'
  end

  def and_they_must_see_updated_article
    expect(find('#title-1').text).to eq "new_#{article.title}"
    expect(find('#content-1').text).to eq "new_#{article.content}"
  end

  def and_they_must_see_initial_article
    expect(find('#title-1').text).to eq article.title
    expect(find('#content-1').text).to eq article.content
  end

  def given_a_user_that_visit_feed_with_articles
    article.save!
    other_article.save!
    last_article.save!
    given_a_user_that_visit_feed
  end

  def given_a_user_that_visit_feed_with_article_and_comment
    article.save!
    comment.save!
    given_a_user_that_visit_feed
  end

  def given_an_other_user_that_visit_feed_with_articles_and_comment
    article.save!
    other_article.save!
    comment.save!

    login_as other_user, :scope => :user
    visit '/feed'
  end

  def they_must_not_be_able_to_delete_or_edit_foreign_article
    expect { find("#icon-#{other_article.id}") }
      .to raise_error Capybara::ElementNotFound
  end

  def when_they_fill_in_inputs_and_choose_article
    find('.create-article .article-title').base.send_keys 'Title'
    find('.create-article .article-content').base.send_keys 'Content'

    find('.fa.fa-pencil').click

    find('.resource').click
  end

  def when_they_fill_in_inputs_and_choose_comment
    find('.create-article .article-title').base.send_keys 'Title'
    find('.create-article .article-content').base.send_keys 'Content'

    and_choose_attachment_comment
  end

  def and_choose_attachment_comment
    find('.fa.fa-comment').click

    find('.resource').click
  end

  def when_they_fill_in_inputs_and_choose_file
    find('.create-article .article-title').base.send_keys 'Title'
    find('.create-article .article-content').base.send_keys 'Content'

    page.execute_script <<-JS
      $('label').css('visibility', 'visible');
      $('label').css('width', 'auto');
      $('label').css('height', 'auto');
      $('#btn').css('visibility', 'visible');
    JS

    attach_file("attachment-file", "#{Rails.root}/spec/support/maxresdefault.jpg")
  #  byebug
#    find('#btn').click
#    byebug
  end

  def then_they_must_see_chosen_article_in_input
    expect{ find('.create-article .article-attachment') }.to_not raise_error
    expect{ find('.create-article .article-attachment i.fa.fa-pencil') }.to_not raise_error

    expect(find('.create-article .article-attachment a#attachment-link')[:href]).to eq '/articles/1'

    expect(find('.create-article .article-attachment .attachment-name').text).to eq article.title
  end

  def then_they_must_see_chosen_comment_in_input
    expect{ find('.create-article .article-attachment') }.to_not raise_error
    expect{ find('.create-article .article-attachment i.fa.fa-comment') }.to_not raise_error

    expect(find('.create-article .article-attachment a#attachment-link')[:href]).to eq '/articles/1#comment1'

    expect(find('.create-article .article-attachment .attachment-name').text).to eq comment.content
  end

  def then_they_must_see_chosen_file_in_input
    expect{ find('.create-article .article-attachment') }.to_not raise_error
    expect{ find('.create-article .article-attachment i.fa.fa-file') }.to_not raise_error

    expect(find('.create-article .article-attachment a#attachment-link')[:href]).to eq '/files/1'
    expect(find('.create-article .article-attachment .attachment-name').text).to eq 'maxresdefault.jpg'
  end

  def when_they_submit_article
    click_button 'Post'
  end

  def when_they_update_article
    click_button 'Update'
  end

  def then_they_must_see_article_with_attachment_article
    expect(find('#title-2').text).to eq 'Title'
    expect(find('#content-2').text).to eq 'Content'

    expect{ find('#attachment-2') }.to_not raise_error

    expect{ find('#attachment-2 i.fa.fa-paperclip') }.to_not raise_error

    expect(find('#attachment-2 a')[:href]).to eq '/articles/1'
  end

  def then_they_must_see_article_with_attachment_comment
    expect(find('#title-2').text).to eq 'Title'
    expect(find('#content-2').text).to eq 'Content'

    expect{ find('#attachment-2') }.to_not raise_error

    expect{ find('#attachment-2 i.fa.fa-paperclip') }.to_not raise_error

    expect(find('#attachment-2 a')[:href]).to eq '/articles/1#comment1'
  end

  def then_they_must_see_article_with_attachment_file
    expect(find('#title-1').text).to eq 'Title'
    expect(find('#content-1').text).to eq 'Content'

    expect{ find('#attachment-1') }.to_not raise_error

    expect{ find('#attachment-1 i.fa.fa-paperclip') }.to_not raise_error

    expect(find('#attachment-1 a')[:href]).to eq '/files/1'

  end
  def they_must_see_two_articles
    expect(page).to have_text article.title
    expect(page).to have_text article.content
    expect(page).to have_text other_article.title
    expect(page).to have_text other_article.content
  end

  def and_they_must_not_see_last_article
    expect(page).to_not have_text last_article.title
    expect(page).to_not have_text last_article.content
  end

  def when_they_click_edit_second_article
    find(".article .menu i#icon-#{other_article.id}").click
    find(".article .menu a#edit-article-#{other_article.id}").click
  end

  def then_they_must_see_other_article_with_attachment_comment
    expect(find('#title-2').text).to eq other_article.title
    expect(find('#content-2').text).to eq other_article.content

    expect{ find('#attachment-2') }.to_not raise_error

    expect{ find('#attachment-2 i.fa.fa-paperclip') }.to_not raise_error

    expect(find('#attachment-2 a')[:href]).to eq '/articles/1#comment1'
  end

  def when_then_submit_article
    click_button 'Post'
  end

  def and_then_click_edit_button
    find(".article .menu i#icon-1").click
    find(".article .menu a#edit-article-1").click
  end

  def then_they_must_see_data_and_file_in_inputs
    expect(find(".create-article .article-title").text).to eq 'Title'
    expect(find(".create-article .article-content").text).to eq 'Content'

    expect(find(".create-article .article-attachment a#attachment-link")[:href]).to eq '/files/1'
    expect(find('.create-article .article-attachment .attachment-name').text).to eq 'maxresdefault.jpg'
  end

end
