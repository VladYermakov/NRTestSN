'use strict'

angular.module 'nrTest'
.controller 'ArticlesCtrl', class ArticlesCtrl

  constructor: ($location, $timeout, $anchorScroll,
                Auth, articles, comments, users) ->

    @comments = comments.comments
    @signedIn = Auth.isAuthenticated()
    @article = articles.article
    @hasAttachment = @article.attachment_id isnt null
    @alive = {}
    @currentUser = users.currentUser

    console.log @article
    console.log @currentUser

    for comment in @comments
      @alive[comment.id] = true

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

    $(window).scroll =>
      if $(window).scrollTop() + $(window).height() == $(document).height()
        console.log 'reached bottom'
        comments.getComments(@article.id).then (res) =>
          for comment in res
            @alive[comment.id] = true

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


    @deleteComment = (comment_id) =>
      comments.destroy(comment_id).then (res) =>
        @alive[comment_id] = false
      , (res) =>
        alert 'You are not able to delete this comment'

    @showEditComment = (comment) =>
      $('.create-comment .comment-content')[0].innerHTML = comment.content
      @content = comment.content
      @updatingComment = comment
      @change()

      $($('.create-comment .comment-content')[0]).focus()

      $('.create-comment .comment-submit')[0].innerHTML = 'Update'
      @createOrUpdateComment = @updateComment
      @updating = true

    @updateComment = =>
      if @content
        @content = @content.replace(/<br>/g, '\n').trim()

      if ! @content or @content is ''
        return

      comments.update(@updatingComment.id, content: @content)

      @updatingComment.content = @content

      @content = '<br>'

      preventValue()

      $('.create-comment .comment-submit')[0].innerHTML = 'Post'
      @createOrUpdateComment = @createComment
      @updating = false

    @abortUpdate = =>
      @content = '<br>'

      preventValue()

      $('.create-comment .comment-submit')[0].innerHTML = 'Post'
      @createOrUpdateComment = @createComment
      @updating = false

    @createComment = =>
      if @content
        @content = @content.replace(/<br>/g, '\n').trim()

      if not @content or @content is ''
        return

      comments.create(@article.id, content: @content).then (comment_id) =>
        @alive[comment_id] = true

      @content = '<br>'
      preventValue()

    @createOrUpdateComment = @createComment
