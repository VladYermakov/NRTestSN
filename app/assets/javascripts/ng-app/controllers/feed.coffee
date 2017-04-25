'use strict'

angular.module 'nrTest'
.controller 'FeedCtrl', class FeedCtrl

  constructor: ($scope, Auth, Upload, users, articles, comments) ->

    @feedArticles = users.feedArticles
    @articles = articles.articles
    @comments = comments.allComments
    @signedIn = Auth.isAuthenticated()
    @attachmentLink = {}
    @attachment = {}
    @alive = {}
    @currentUser = users.currentUser

    $(document).ready =>
      $('.container').css 'width', '670'
      $('.container-navbar').css 'width', '670'

    $(window).scroll =>
      if $(window).scrollTop() + $(window).height() == $(document).height()
        console.log 'reached bottom'
        comments.getAll()
        articles.getAll()
        users.getFeed().then (res) =>
          for article in res
            @alive[article.id] = true

            attachLink(@attachmentLink, article)

    attachLink = (link, article) =>
      if article.attachment_type is 'Article'
        link[article.id] = '/articles/' + article.attachment_id

      else if article.attachment_type is 'Comment'
        comments.get(article.attachment_id).then (com) =>
          link[article.id] = '/articles/' +  com.article_id + '#comment' + article.attachment_id

      else if article.attachment_type is 'AttachmentFile'
        link[article.id] = '/files/' + article.attachment_id

    for article in @feedArticles
      @alive[article.id] = true

      attachLink(@attachmentLink, article)

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

    @showEditArticle = (article) =>
      $(".create-article .article-title")[0].innerHTML = article.title
      @title = article.title
      $(".create-article .article-content")[0].innerHTML = article.content
      @content = article.content
      @updatingArticle = article
      @change('title')
      @change('content')

      $($('.create-article .article-title')[0]).focus()

      attachLink(@attachment, article)

      @attachment.link = @attachment[@updatingArticle.id]
      if article.attachment_type is 'Article'
        @attachment.type = 'article'
        @attachment.icon = 'pencil'
        articles.get(article.attachment_id).then (res) =>
          @attachment.name = res.title
      else if article.attachment_type is 'Comment'
        @attachment.type = 'comment'
        @attachment.icon = 'comment'
        comments.get(article.attachment_id).then (res) =>
          @attachment.name = res.content
      else if article.attachment_type is 'AttachmentFile'
        @attachment.type = 'attachment_file'
        @attachment.icon = 'file'
        articles.getAttachment(article.attachment_id).then (res) =>
          @attachment.name = res.source_file_name

      @createOrUpdateArticle = @updateArticle
      @updating = true
      $('.create-article .article-submit')[0].innerHTML = 'Update'

    @abortUpdating = =>
      @title = ''
      $(".create-article .article-title")[0].innerHTML = ''
      @content = ''
      $(".create-article .article-content")[0].innerHTML = ''
      @deleteLink()

      @change('title')
      @change('content')

      @createOrUpdateArticle = @addArticle
      @updating = false

      $('.create-article .article-submit')[0].innerHTML = 'Post'

    @updateArticle = =>
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

      articles.update(@updatingArticle.id, title: @title, content: @content).then =>
        if attachment.file
          @uploadFromPromise(@updatingArticle, attachment.file).then =>
            attachLink(@attachmentLink, @updatingArticle)

        if attachment.article and attachment.article isnt ''
          articles.updateAttachment @updatingArticle.id, 'article', id: attachment.article
          @updatingArticle.attachment_type = 'Article'
          @updatingArticle.attachment_id = attachment.article

        if attachment.comment and attachment.comment isnt ''
          articles.updateAttachment @updatingArticle.id, 'comment', id: attachment.comment
          @updatingArticle.attachment_type = 'Comment'
          @updatingArticle.attachment_id = attachment.comment

        attachLink(@attachmentLink, @updatingArticle)

      @updatingArticle.title = @title
      @updatingArticle.content = @content

      @title = ''
      $(".create-article .article-title")[0].innerHTML = ''
      @content = ''
      $(".create-article .article-content")[0].innerHTML = ''

      @article = null
      @comment = null
      @filePromise = null
      @deleteLink()

      @change('title')
      @change('content')

      @createOrUpdateArticle = @addArticle
      @updating = false

      $('.create-article .article-submit')[0].innerHTML = 'Post'

    @upload = =>
      console.log @file
      if not @file
        return

      xcsrf = document.querySelector('meta[name="csrf-token"]')
      if xcsrf
        xcsrf = xcsrf.getAttribute 'content'

      options =
        url:    Routes.api_attachments_path('json')
        method: 'POST'
        headers:
          'X-CSRF-Token': xcsrf
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

    @uploadFromPromise = (article, filePromise) =>
      filePromise.then (res) =>
        articles.updateAttachment article.id, 'attachment_file', id: res.data.id
        article.attachment_type = 'AttachmentFile'
        article.attachment_id = res.data.id

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
      console.log @title, @content
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
          @uploadFromPromise(@feedArticles[0], attachment.file).then =>
            attachLink(@attachmentLink, article)

        if attachment.article and attachment.article isnt ''
          articles.updateAttachment article.id, 'article', id: attachment.article
          @feedArticles[0].attachment_type = 'Article'
          @feedArticles[0].attachment_id = attachment.article

        if attachment.comment and attachment.comment isnt ''
          articles.updateAttachment article.id, 'comment', id: attachment.comment
          @feedArticles[0].attachment_type = 'Comment'
          @feedArticles[0].attachment_id = attachment.comment

        attachLink(@attachmentLink, @feedArticles[0])

        @alive[article.id] = true

      @title = ''
      $(".create-article .article-title")[0].innerHTML = ''
      @content = ''
      $(".create-article .article-content")[0].innerHTML = ''

      @article = null
      @comment = null
      @filePromise = null
      @deleteLink()

      @change('title')
      @change('content')

    @createOrUpdateArticle = @addArticle
