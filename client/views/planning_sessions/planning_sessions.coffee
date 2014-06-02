Template.planningSessionEdit.events
  'change input[type=text]': (evt) ->
    name = evt.target.name
    modifier =
      $set: {}
    modifier.$set[name] = evt.target.value
    PlanningSessions.update this._id, modifier
  'change select#pt-projects': (evt) ->
    user = Meteor.user()
    projectId = evt.target.value
    if user.profile.pt && user.profile.pt.token && projectId
      HTTP.get PT.API_URL + 'projects/' + projectId + '/stories?filter=state:unstarted,unscheduled type:feature,bug,chore',
        headers:
          'X-TrackerToken': user.profile.pt.token
      ,
        (error, result) ->
          stories = result.data
          _.each stories, (s) ->
            PTStories.insert s

Template.planningSessionEdit.rendered = ->
  user = Meteor.user()
  if user.profile.pt && user.profile.pt.token
    HTTP.get PT.API_URL + 'projects',
      headers:
        'X-TrackerToken': user.profile.pt.token
    ,
      (error, result) ->
        if !error
          projects = result.data
          _.each projects, (p) ->
            PTProjects.insert p
