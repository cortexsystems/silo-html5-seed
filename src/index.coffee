View = require './view'

# This HTML5 application is meant to be delivered by the ad server and
# displayed inside the Vistar ads application. When the ad server returns
# this HTML5 app, Vistar app will load it inside an iframe and keep the iframe
# around for as long as possible. There are two important points to keep in
# mind:
#
# * The HTML5 application doesn't know if it's being displayed on the screen at
#   any time. It's best to assume we're always visible and be prepared for
#   that. Ideally, as soon as this application starts, it should modify the DOM
#   to display some content. Later on, it should modify the DOM based on the
#   data it receives.
# * The parent application will try to keep this app around for as long as
#   possible without destroying the JS context. In other words, the same
#   instance of this application may be used for multiple spots. The
#   application should not assume that it will get reloaded everytime the
#   player displays it on screen.

# For this sample application we have a single view that displays the incoming
# JSON data on screen.
view = new View()

main = ->
  # Cortex player will fire a 'cortex-ready' event once the application is
  # initialized. This event will get fired only once during the lifetime of
  # the application.
  #
  # Cortex API is available only after the 'cortex-ready' event.
  window.addEventListener 'cortex-ready', ->
    # We should start rendering some content immediately without waiting for
    # the data to arrive.
    view.renderDefault()

    # We use Cortex.onData to register a listener for a dataset. Whenever
    # the requested dataset changes, this listener will get called with the
    # new data rows relevant to this player.
    window.Cortex?.onData 'com.cortexpowered.test-dataset', view.onData

    # An application can listen to any number of dataset changes. It is
    # important to not rely on the order of incoming data events.
    # window.Cortex.onData 'com.cortexpowered.other-dataset', view.onOtherData

  ###
  # Uncomment this part to test the application on a browser. Make sure you
  # comment out this part before packaging the application for Cortex.
  init = ->
    window.dispatchEvent new Event 'cortex-ready'

    sendData = ->
      apollo = [
        {id: 1, name: "The Dancing Destroyer"}
        {id: 2, name: "The King of Sting"}
        {id: 3, name: "The Count of Monte Fisto"}
        {id: 4, name: "The Prince of Punch"}
        {id: 5, name: "The Master of Disaster"}
        {id: 6, name: "The One and Only"}
      ]

      view.onData apollo

    setTimeout sendData, 1000
  setTimeout init, 1000
  ###

module.exports = main()
