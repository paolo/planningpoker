# Planning Poker
# @author Paolo Castro <paolo.castro@jalasoft.com>

# Votes collection
@Votes = new Meteor.Collection 'votes'

if Meteor.isServer
  # Publications

  # Publish votes without the actual vote value.
  Meteor.publish 'votes', (planId, storyId) ->
    Votes.find planId: planId, storyId: storyId, closed: false,
      fields: planId: 1, storyId: 1, owner: 1, status: 1

  Meteor.methods
    castVote: (planId, storyId, value) ->
      if !@userId
        throw new Meteor.Error 401, 'Unable to access'
      vote = Votes.findOne planId: planId, storyId: storyId, owner: @userId, closed: false
      if vote
        Votes.update vote._id, $set: value: value, status: 'casted'
      else
        user = Meteor.users.findOne @userId
        Votes.insert
          planId: planId
          storyId: storyId
          owner: @userId
          ownerName: user.displayName
          value: value
          status: 'casted'
          closed: false

if Meteor.isClient
  Tracker.autorun ->
    if Session.get('__planId')
      plan = PlanningSessions.findOne Session.get('__planId')
      if plan.selectedStory && plan.votingOn
        Meteor.subscribe 'votes', plan._id, plan.selectedStory
