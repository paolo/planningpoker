Router.map () ->
  @route 'planningSessionEdit',
    path: "/plans/:_id/edit"
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
  @route 'planningSessionLive',
    path: '/plans/:_id/live'
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
    if !PlanningSessions.findOne @params._id
      Router.go '/404'
    else
      Meteor.call 'loadProjects', @params._id
      @render 'planningSessionEdit'

  # Live Planning session.
  live: ->
    plan = PlanningSessions.findOne @params._id
    if plan && plan.started && !plan.closed
      @render 'planningSessionLive'
    else
      Router.go '/404'
