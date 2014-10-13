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

if Meteor.isClient
  Tracker.autorun ->
    console.log 'autorun'
    if Session.get('__planId')
      plan = PlanningSessions.findOne Session.get('__planId')
      if plan.selectedStory && plan.votingOn
        Meteor.subscribe 'votes', plan._id, plan.selectedStory
