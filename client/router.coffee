Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'

Router.map () ->
  @route 'index',
    path: "/"
    controller: 'CoreController'
    action: 'index'