# Planning Poker
# @author: Paolo Castro <paolocastro.deb@gmail.com>

# PlanningSessions Collection
@PlanningSessions = new Meteor.Collection 'planningSessions'

# Allow Rules
@PlanningSessions.allow
  insert: (userId) ->
    if !userId
      throw Meteor.Error 403, 'You need to login to perform this operation'
    true
  update: (userId, doc) ->
    if !userId || userId != doc.owner
      throw Meteor.Error 403, 'You\'re not authorized to perform this operation'
    true
  remove: (userId, doc) ->
    if !userId || userId != doc.owner
      throw Meteor.Error 403, 'You\'re not authorized to perform this operation'
    true

# Planning sessions publications
if Meteor.isServer

  # Give the planning session ownership to a different user.
  Meteor.methods
    giveOwnership: (planId, userId) ->
      owner = Meteor.user()
      if !owner
        throw new Meteor.Error 403, 'Unable to access'
      plan = PlanningSessions.findOne planId
      if !plan
        throw new Meteor.Error 404, 'No such planning session'
      user = Meteor.users.findOne userId
      if !user
        throw new Meteor.Error 404, 'No such user'
      if plan.owner != owner._id
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
        Votes.insert
          planId: planId
          storyId: storyId
          owner: userId
          status: 'open'
          closed: false

    closeVoting: (planId) ->
      if !@userId
        throw new Meteor.Error 403, 'Unable to access'
      plan = PlanningSessions.findOne planId
      if !plan
        throw new Meteor.Error 404, 'No such planning session'
      if plan.owner != @userId
        throw new Meteor.Error 401, 'Unauthorized operation'
      PlanningSessions.update planId, $set: votingOn: ''

  # Publish a Planning session by id algon with the users connected to it
  Meteor.publish 'planningSession', (id) ->
    [
      PlanningSessions.find(_id: id)
      Meteor.users.find('profile.currentPlan': id, 'status.online': true)
    ]

if Meteor.isClient
  Tracker.autorun ->
    if PlanningSessions.find().count() == 1
      Session.set('__planId', PlanningSessions.findOne()._id)
    else
      Session.set('__planId', '')
    if Meteor.userId()
      Meteor.users.update Meteor.userId(),
        $set:
          'profile.currentPlan': Session.get('__planId')
