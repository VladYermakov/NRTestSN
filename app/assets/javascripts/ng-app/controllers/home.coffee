'use strict'

angular.module 'nrTest'
.controller 'HomeCtrl', class HomeCtrl

  constructor: (articles, comments) ->

    @articles = articles.articles
    @attachmentLink = {}

    $(document).ready =>
      $('.container').css 'width', '960'
      $('.container-navbar').css 'width', '960'

    $(window).scroll ->
      if $(window).scrollTop() + $(window).height() == $(document).height()
        articles.getAll()

    attachLink = (article) =>
      if article.attachment_type is 'Article'
        @attachmentLink[article.id] = '/articles/' + article.attachment_id

      else if article.attachment_type is 'Comment'
        comments.get(article.attachment_id).then (com) =>
          @attachmentLink[article.id] = '/articles/' +  com.article_id + '#comment' + article.attachment_id

      else if article.attachment_type is 'AttachmentFile'
        @attachmentLink[article.id] = '/files/' + article.attachment_id

    for article in @articles
      attachLink(article)

    @hasAttachment = (article) =>
      article.attachment_id isnt null
