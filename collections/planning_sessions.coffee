# Planning Poker
# @author: Paolo Castro <paolocastro.deb@gmail.com>

# PlanningSessions Collection
@PlanningSessions = new Meteor.Collection 'planningSessions'

# Allow Rules
@PlanningSessions.allow
  insert: (userId) ->
    throw Meteor.Error 403, 'Access forbidden' unless userId
    true
  update: (userId, doc) ->
    throw Meteor.Error 403, 'Access forbidden' unless userId and userId is doc.owner
    true
  remove: (userId, doc) ->
    throw Meteor.Error 403, 'Access forbidden' unless userId and userId is doc.owner
    true

# Planning sessions publications
if Meteor.isServer

  # Give the planning session ownership to a different user.
  Meteor.methods
    giveOwnership: (planId, userId) ->
      owner = Meteor.user()
      throw new Meteor.Error 403, 'Unable to access' unless owner
      plan = PlanningSessions.findOne planId
      throw new Meteor.Error 404, 'No such planning session' unless plan
      user = Meteor.users.findOne userId
      throw new Meteor.Error 404, 'No such user' unless user
      if plan.owner isnt owner._id
        throw new Meteor.Error 401, 'Unauthorized operation'
      PlanningSessions.update planId,
        $set:
          owner: userId

    openVoting: (planId, storyId, currentUsers) ->
      if !@userId
        throw new Meteor.Error 403, 'Unable to access'
      plan = PlanningSessions.findOne planId
      if !plan
        throw new Meteor.Error 404, 'No such planning session'
      if plan.owner != @userId
        throw new Meteor.Error 401, 'Unauthorized operation'
      PlanningSessions.update planId, $set: votingOn: storyId
      @unblock()
      _.each currentUsers, (userId) ->
        user = Meteor.users.findOne userId
        Votes.insert
          planId: planId
          storyId: storyId
          owner: userId
          ownerName: user.displayName
          status: 'open'
          closed: false
          value: '?'

    closeVoting: (planId, storyId) ->
      if !@userId
        throw new Meteor.Error 403, 'Unable to access'
      plan = PlanningSessions.findOne planId
      if !plan
        throw new Meteor.Error 404, 'No such planning session'
      if plan.owner != @userId
        throw new Meteor.Error 401, 'Unauthorized operation'
      story = Stories.findOne storyId
      if !story
        throw new Meteor.Error 404, 'No such user story'
      votes = Votes.find(planId: planId, storyId: storyId, closed: false).map (v) -> v._id
      resultId = Meteor.call 'createResult', planId, storyId, votes
      Votes.update planId: planId, storyId: storyId, closed: false,
        $set: closed: true
      ,
        multi: true
      PlanningSessions.update planId, $set:
        votingOn: ''
        lastResultId: resultId

  # Publish a Planning session by id along with the users connected to it
  Meteor.publish 'planningSession', (id) ->
    [
      PlanningSessions.find(_id: id)
      Meteor.users.find('profile.currentPlan': id, 'status.online': true)
    ]

if Meteor.isClient
  Tracker.autorun ->
    if PlanningSessions.find().count() is 1
      Session.set '__planId', PlanningSessions.findOne()._id
    else
      Session.set '__planId', ''
    if Meteor.userId()
      Meteor.users.update Meteor.userId(),
        $set:
          'profile.currentPlan': Session.get '__planId'
