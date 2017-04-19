'use strict'

angular.module 'nrTest'
.controller 'FeedCtrl', class FeedCtrl

  constructor: (Auth, Upload, users, articles, comments) ->

    @feedArticles = users.feedArticles
    @articles = articles.articles
    @comments = comments.allComments
    @signedIn = Auth.isAuthenticated()
    @attachmentLink = {}
    @attachment = {}
    @alive = {}

    $(document).ready =>
      $('.container').css 'width', '670'
      $('.container-navbar').css 'width', '670'

    attachLink = (article) =>
      if article.attachment_type is 'Article'
        @attachmentLink[article.id] = '/articles/' + article.attachment_id

      else if article.attachment_type is 'Comment'
        comments.get(article.attachment_id).then (com) =>
          @attachmentLink[article.id] = '/articles/' +  com.article_id + '#comment' + article.attachment_id

      else if article.attachment_type is 'AttachmentFile'
        @attachmentLink[article.id] = '/files/' + article.attachment_id

    for article in @feedArticles
      @alive[article.id] = true

      attachLink(article)

    @focus = (input) ->
      $(".create-article .article-#{input}")[0].focus()

    @change = (input) ->
      value = $(".create-article .article-#{input}")[0].innerHTML

      if not value or value is '' or value is '<br>'
        $(".create-article .#{input}.placeholder").css('visibility', 'visible')
      else
        $(".create-article .#{input}.placeholder").css('visibility', 'hidden')

    @deleteArticle = (article_id) =>
      articles.destroy(article_id).then (res) =>
        @alive[article_id] = false
      , (res) ->
        alert 'You are not able to delete this article'

    @editArticle = (article_id) =>
      # TODO:

    @upload = =>
      if not @file
        return

      options =
        url:    Routes.api_attachments_path('json')
        method: 'POST'
        headers:
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        file: @file
        data:
          source: @file

      @filePromise = Upload.upload(options)

      @filePromise.then (res) =>
        @attachment.type = 'attachment_file'
        @attachment.link = '/files/' + res.data.id
        @attachment.name = res.data.source_file_name
        @attachment.icon = 'file'

      @file = null

    @uploadFromPromise = (article_id, filePromise) =>
      filePromise.then (res) =>
        articles.updateAttachment article_id, 'attachment_file', id: res.data.id
        @articles[0].attachment_type = 'AttachmeFile'
        @articles[0].attachment_id = res.data.id

    @deleteLink = =>
      @attachment.link = null

    @hasAttachment = (article) ->
      article.attachment_id isnt null

    @showChoose = (resource) =>
      $('#layer-bg').css 'display', 'block'
      $('#resources-layer').css 'display', 'block'
      $('body').css 'overflow', 'hidden'

      if resource is 'Article'
        @resources = @articles
      else
        @resources = @comments
      @resourceType = resource

    @getTitle = (resourceType, resource) =>
      if resourceType is 'Article'
        resource.title
      else
        resource.content

    @chooseResource = (resourceType, resource) =>
      if resourceType is 'Article'
        chooseArticle resource
      else
        chooseComment resource

      @hideAll()

    chooseArticle = (article) =>
      @attachment.type = 'article'
      @attachment.link = '/articles/' + article.id
      @attachment.name = article.title
      @attachment.icon = 'pencil'
      @article = article.id

    chooseComment = (comment) =>
      @attachment.type = 'comment'
      @attachment.link = '/articles/' + comment.article_id + '#comment' + comment.id
      @attachment.name = comment.content
      @attachment.icon = 'comment'
      @comment = comment.id

    @hideAll = ->
      $('#layer-bg').css 'display', 'none'
      $('#resources-layer').css 'display', 'none'
      $('body').css 'overflow-y', 'scroll'

    @addArticle = =>
      if @title
        @title = @title.replace(/<br>/g, '').trim()

      if @content
        @content = @content.replace(/<br>/g, '\n')
                           .replace(/&gt;/g, '>')
                           .replace(/&lt;/, '<')
                           .trim()

      if not @title or @title is '' or @title is '\n' or
         not @content or @content is '' or @content is '\n'

        if not @title or @title is '' or @title is '\n'
          $('.create-article .article-title').css 'border', '1px solid red'
          $('.create-article .article-title').on 'click', ->
            $('.create-article .article-title').css 'border', 'none'
            $('.create-article .article-title').off 'click'

        if not @content or @content is '' or @content is '\n'
          $('.create-article .article-content').css 'border', '1px solid red'
          $('.create-article .article-content').on 'click', ->
            $('.create-article .article-content').css 'border', 'none'
            $('.create-article .article-content').off 'click'

        return

      attachment =
        file:    @filePromise
        article: @article
        comment: @comment

      articles.create(title: @title, content: @content).then (article) =>
        @feedArticles.unshift(article)

        if attachment.file
          @uploadFromPromise article.id, attachment.file

        if attachment.article && attachment.article isnt ''
          articles.updateAttachment article.id, 'article', id: attachment.article
          @feedArticles[0].attachment_type = 'Article'
          @feedArticles[0].attachment_id = attachment.article

        if attachment.comment && attachment.comment isnt ''
          articles.updateAttachment article.id, 'comment', id: attachment.comment
          @feedArticles[0].attachment_type = 'Comment'
          @feedArticles[0].attachment_id = attachment.comment

        attachLink(@feedArticles[0])

        @alive[article.id] = true

      @title = ''
      @content = ''

      @article = null
      @comment = null
      @filePromise = null
      @deleteLink()

      $(".create-article .title.placeholder").css 'visibility', 'visible'
      $(".create-article .content.placeholder").css 'visibility', 'visible'
