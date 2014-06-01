Router.map () ->
  @route 'planningSessionEdit',
    path: "/plans/:_id/edit"
    controller: 'PlanningSessionsController'
    action: 'edit'

class @PlanningSessionsController extends RouteController
  waitOn: ->
    Meteor.subscribe 'planningSession', @params._id
  data: ->
    session: PlanningSessions.findOne @params._id
    projects: PTProjects.find().fetch()
    stories: PTStories.find().fetch()
  edit: ->
    if !PlanningSessions.findOne @params._id
      Router.go '/404'
    else
      @render 'planningSessionEdit'
