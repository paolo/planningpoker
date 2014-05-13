Template.signUp.events
  'submit': (event) ->
    event.preventDefault()
    username = $(event.target).find("[type=text]").val()
    email = $(event.target).find("[type=email]").val()
    password = $(event.target).find("[type=password]").val()
    Accounts.createUser
      username: username
      email: email
      password: password
    ,
      (error) ->
        if error
          console.log error
        else
          Router.go 'index'

Template.login.events
  'submit': (event) ->
    event.preventDefault()
    email = $(event.target).find("[type=email]").val()
    password = $(event.target).find("[type=password]").val()
    Meteor.loginWithPassword {email: email}, password, (error) ->
      if error
        console.log 'login failed'
