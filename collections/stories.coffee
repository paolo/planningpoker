# Planning Poker
# @author: Paolo Castro <paolocastro.deb@gmail.com>

# Stories Collection
@Stories = new Meteor.Collection "stories"

Stories._transform = (story) ->
  unless story.estimate
    story.estimate = "?"
  story

# Server methods
Meteor.methods

  # Load project user stories.
  # @param {String} planning session id.
  loadStories: (planId) ->
    user = Meteor.users.findOne @userId
    plan = PlanningSessions.findOne
      _id: planId
      owner: user._id
    if !plan
      throw new Meteor.Error 404, "No such planning session found"
    if !plan.projectId
      throw new Meteor.Error 400, "Planning session has no project"
    project = Projects.findOne plan.projectId
    if !project
      throw new Meteor.Error 404, "Unable to find the selected project"
    @unblock()
    if user.profile.pt && user.profile.pt.token
      headers = {}
      headers[PT.TOK_HEADER] = user.profile.pt.token
      filter = 'filter=state:unstarted,unscheduled'
      unless @isSimulation
        HTTP.get PT.API_URL + 'projects/' + project.externalId + '/stories?' + filter,
          headers: headers, (err, result) ->
            unless err
              stories = result.data
              _.each stories, (s) ->
                Stories.upsert
                  projectId: project._id
                  externalId: s.id
                ,
                  $set:
                    externalId: s.id
                    projectId: project._id
                    storyType: s.story_type
                    name: s.name
                    description: s.description
                    currentState: s.current_state
                    url: s.url
                    deadline: s.deadline
                    estimateable: s.story_type == 'feature'
                    estimate: s.estimate

# Stories publications
if Meteor.isServer

  # Planning session user stories
  # @param {String} planning session id.
  Meteor.publish "planStories", (planId) ->
    plan = PlanningSessions.findOne planId
    if plan && plan.projectId
      project = Projects.findOne plan.projectId
      if project
        Stories.find
          projectId: project._id
