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

  # Publish a Planning session by id.
  Meteor.publish 'planningSession', (id) ->
    PlanningSessions.find _id: id

if Meteor.isClient
  Tracker.autorun ->
    if PlanningSessions.find().count() == 1
      Session.set('__planId', PlanningSessions.findOne()._id)
    else
      Session.set('__planId', '')
