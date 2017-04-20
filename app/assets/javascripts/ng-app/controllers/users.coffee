'use strict'

angular.module 'nrTest'
.controller 'UsersCtrl', class UsersCtrl

  constructor: (Auth, articles, comments, users) ->

    MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July',
              'August', 'September', 'October', 'November', 'December']

    @articles = articles.userArticles
    @user = @articles[0].user
    @attachmentLink = {}

    Auth.currentUser().then (user) =>
      console.log user, @user
      @showFU = @user.id != user.id

    users.following(@user.id).then (res) =>
      @fu = if res.data then 'Unfollow' else 'Follow'

    @user.following_count = users.following_count
    @user.followers_count = users.followers_count

    $(document).ready ->
      $('.container').css 'width', '960'
      $('.container-navbar').css 'width', '960'

    attachLink = (article) =>
      if article.attachment_type is 'Article'
        @attachmentLink[article.id] = '/articles/' + article.attachment_id

      else if article.attachment_type is 'Comment'
        comments.get(article.attachment_id).then (com) =>
          @attachmentLink[article.id] = '/articles/' +  com.article_id + '#comment' + article.attachment_id

      else if article.attachment_type is 'AttachmentFile'
        @attachmentLink[article.id] = '/files/' + article.attachment_id

    for article in @articles
      attachLink article

    @hasAttachment = (article) ->
      article.attachment_id isnt null

    formatDate = (date) ->
      console.log date
      "#{date.getDate()} of #{getMonthName(date.getMonth())} #{date.getFullYear()}"

    getMonthName = (monthNo) ->
      MONTHS[monthNo]

    @formatDate = formatDate(new Date(@user.created_at))

    @toggleFollow = =>
      if @fu == 'Unfollow'
        @fu = 'Follow'
        users.unfollow(@user.id)
        @user.followers_count -= 1
      else
        @fu = 'Unfollow'
        users.follow(@user.id)
        @user.followers_count += 1
