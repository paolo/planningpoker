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

  # Publish a Planning session by id.
  Meteor.publish 'planningSession', (id) ->
    PlanningSessions.find _id: id