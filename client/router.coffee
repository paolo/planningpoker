Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'

Router.map () ->
  @route 'index',
    path: "/"
    controller: 'CoreController'
    action: 'index'
  @route 'signUp',
    path: '/signUp'
    controller: 'CoreController'
    action: 'signUp'
  @route 'login',
    path: '/login'
    controller: 'CoreController'
    action: 'login'
  @route 'logout',
    path: '/logout'
    controller: 'CoreController'
    action: 'logout'