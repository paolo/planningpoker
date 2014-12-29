Router.route '/plans/:_id/edit',
  name: 'planningSessionEdit'
  controller: 'PlanningSessionsController'
  action: 'edit'
  waitOn: ->
    [
      Meteor.subscribe 'planningSession', @params._id
      Meteor.subscribe 'planProjects', @params._id
    ]
  data: ->
    session: PlanningSessions.findOne @params._id
    projects: Projects.find().fetch()

Router.route '/plans/:_id/live',
  name: 'planningSessionLive'
  controller: 'PlanningSessionsController'
  action: 'live'
  waitOn: ->
    [
      Meteor.subscribe 'planningSession', @params._id
      Meteor.subscribe 'planProject', @params._id
      Meteor.subscribe 'planStories', @params._id
    ]
  data: ->
    session: PlanningSessions.findOne @params._id
    project: Projects.findOne()
    stories: Stories.find()
    users: Meteor.users.find()

class @PlanningSessionsController extends RouteController
  # Edit Planning session
  edit: ->
    unless PlanningSessions.findOne @params._id
      Router.go '/404'
    else
      Meteor.call 'loadProjects', @params._id
      @render 'planningSessionEdit'

  # Live Planning session.
  live: ->
    plan = PlanningSessions.findOne @params._id
    if plan and plan.started and !plan.closed
      if @params.query? and @params.query.view? and @params.query.view is "stories"
        Session.set('planningSessionLiveView', 'stories')
      else if @params.query? and @params.query.view? and @params.query.view is "users"
        Session.set('planningSessionLiveView', 'users')
      else
        Session.set('planningSessionLiveView', 'board')
      @render 'planningSessionLive'
    else
      Router.go '/404'
