# PlanningPoker
# @author: Paolo Castro <paolocastro.deb@gmail.com>


# Projects Collection
@Projects = new Meteor.Collection 'projects'

# Server methods
Meteor.methods

  # Load user projects.
  #
  # @param {String} planId PlanningSession's id.
  loadProjects: (planId) ->
    user = Meteor.users.findOne(@userId)
    if !PlanningSessions.findOne planId
      throw new Meteor.Error 404, 'No such planning session available'
    @unblock()
    if user.profile.pt && user.profile.pt.token
      headers = {}
      headers[PT.TOK_HEADER] = user.profile.pt.token
      if !@isSimulation
        HTTP.get PT.API_URL + 'projects', {headers: headers}, (err, result) ->
          if !err
            projects = result.data
            _.each projects, (p) ->
              Projects.upsert
                provider: PT.PROVIDER
                externalId: p.id
              ,
                $set:
                  name: p.name
                  provider: PT.PROVIDER
                  externalId: p.id
                $addToSet:
                  planIds: planId

# Projects publications.
if Meteor.isServer

  # Publish projects by one of the planning session it was part of
  Meteor.publish 'planProjects', (planId) ->
    Projects.find
      planIds:
        $in: [planId]

  # Publish the selected project for the planning session
  Meteor.publish 'planProject', (planId) ->
    plan = PlanningSessions.findOne planId
    if plan
      Projects.find
        _id: plan.projectId
