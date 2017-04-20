'use strict'

angular.module 'nrTest'
.controller 'ArticlesCtrl', class ArticlesCtrl

  constructor: ($location, $timeout, $anchorScroll, Auth, articles, comments) ->

    @comments = comments.comments
    @signedIn = Auth.isAuthenticated()
    @article = articles.article
    @hasAttachment = @article.attachment_id isnt null

    preventValue = =>
      $(".create-comment .comment-content")[0].innerHTML = '<br>'
      @change()

    $(document).ready =>
      commentHash = $location.hash()
      $anchorScroll()

      $($("[name='#{commentHash}']").parent()).css('background', '#e4eaf0')

      $timeout ->
        $($("[name='#{commentHash}']").parent()).css('background', 'none')
      , 500

      $('.container').css 'width', '670'
      $('.container-navbar').css 'width', '670'

      if @signedIn
        preventValue()

    @focus = =>
      $(".create-comment .comment-content")[0].focus()

    @change = =>
      value = $(".create-comment .comment-content")[0].innerHTML

      if not value or value is '' or value is '<br>'
        $(".create-comment .content.placeholder").css('visibility', 'visible')
      else
        $(".create-comment .content.placeholder").css('visibility', 'hidden')


    if @article.attachment_type is 'Article'
      @attachmentLink = '/articles/' + @article.attachment_id

    else if @article.attachment_type is 'Comment'
      comments.get(@article.attachment_id).then (com) =>
        @attachmentLink = '/articles/' +  com.article_id + '/#' + @article.attachment_id

    else if @article.attachment_type is 'AttachmentFile'
      @attachmentLink = '/files/' + @article.attachment_id


    @createComment = =>
      if @content
        @content = @content.replace(/<br>/g, '\n').trim()

      if not @content or @content is ''
        return

      comments.create(@article.id, content: @content)

      @content = '<br>'
      preventValue()
