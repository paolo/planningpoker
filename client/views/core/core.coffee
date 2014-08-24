Template.signUp.events
  'submit': (event) ->
    event.preventDefault()
    username = $(event.target).find("[type=text]")
    email = $(event.target).find("[type=email]")
    password = $(event.target).find("[type=password]")
    Accounts.createUser
      username: username.val()
      email: email.val()
      password: password.val()
    ,
      (error) ->
        if error
          username.parent().addClass("has-error")
          email.parent().addClass("has-error")
          password.parent().addClass("has-error")
          new PNotify
            text: "Sign up failed"
            type: "error"
          username.focus()
        else
          new PNotify
            text: "Welcome!"
            type: "success"
          Router.go 'index'

Template.login.events
  'submit': (event) ->
    event.preventDefault()
    username = $(event.target).find("[name=username]")
    password = $(event.target).find("[type=password]")
    Meteor.loginWithPassword username.val(), password.val(), (error) ->
      if error
        username.parent().addClass("has-error")
        password.parent().addClass("has-error")
        username.focus()
        new PNotify
          title: "Login Failed"
          text: "Incorrect username or password"
          type: "error"
      else
        new PNotify
          title: "Welcome back!"
          type: "success"
      username.val ""
      password.val ""

Template.index.events
  'click .host': ->
    id = PlanningSessions.insert
      name: moment().format 'L'
      owner: Meteor.userId()
    , (error) ->
      if error
        console.log error.reason
    if id
      Router.go 'planningSessionEdit', {_id: id}
