# We can use any module installed with npm.
moment = require 'moment'

# Main view.
# - Displays a default message on screen until it receives some data from
#   Silo.
# - When new data records arrive, display them on screen.
class View
  constructor: ->

  renderDefault: ->
    content = document.getElementById 'content'
    content.innerHTML = '<p>No data.</p>'

  # Data listener registered in index.coffee.
  # When the application loads initially, Silo will send down the relevant
  # records of the requested dataset to this listener. Later on, this listener
  # will get called whenever there is a change to the requested dataset. Here
  # are some important points:
  #
  # - Application shouldn't make any assumptions about when this listener will
  #   get called.
  # - Passed data array may be empty (e.g. all records for this device got
  #   deleted). It is upto the application to decide what to do. Generally, the
  #   application should either display some fallback content or use the data
  #   from previous calls when stale data is not a problem.
  # - Each listener call gets the complete set of records for the device this
  #   application runs on. If there are records, you can discard the old
  #   records completely. And if there are no records, it means currently the
  #   dataset doesn't have any records for the device. You can either show the
  #   fallback content or use the data from a previous listener call.
  onData: (rows) =>
    # For this simple application we display the 'No data' message until we get
    # a non-empty dataset. From that point on, we change the content only when
    # we receive some new records.
    if rows?.length > 0
      content = document.getElementById 'content'

      pre = document.createElement 'pre'

      pre.appendChild document.createTextNode(
        "Update time: #{moment().format()}")
      pre.appendChild document.createElement('br')
      pre.appendChild document.createElement('br')

      json = JSON.stringify rows, null, 2
      pre.appendChild document.createTextNode(json)

      content.replaceChild pre, content.firstChild

module.exports = View
