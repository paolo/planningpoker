@PlanningSessions = new Meteor.Collection 'planningSessions'

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

if Meteor.isServer
  Meteor.publish 'planningSession', (id) ->
    PlanningSessions.find _id: id