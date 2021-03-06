command: 'curl -s "http://api.open-notify.org/astros.json"'

#refresh daily
refreshFrequency: 21000000

style: """
  position: absolute
  top: 20px
  left: 20px
  color: #fff

  .output p,
  .output ul
    margin: 0

  .output
    font-family: Helvetica Neue
    font-size: 20px
    font-weight: 200
    text-shadow: 0 1px 5px #000000;

  ul li
    font-size: 16px

  #error
    display: none
"""

render: (output) -> """
  <div class="output">
    <p id="success">
      <span id="num">?</span> People in Space right now<br>
      <ul id="people"></ul>
    </p>
    <p id="error">Not sure how many people are in space...</p>
  </div>
"""

# credit goes to https://github.com/eanplatter/minimal-github-widgit
afterRender: (widget) ->
  # this is a bit of a hack until jQuery UI is included natively
  $.ajax({
    url: "https://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js",
    cache: true,
    dataType: "script",
    success: ->
      $(widget).draggable()
      return
  })

update: (output, domEl) ->
  try
    jsonData = jQuery.parseJSON(output)
    success = jsonData.message == "success"
  catch e
    success = false

  $(domEl).find('#error').toggle( !success )
  $(domEl).find('#success').toggle( success )

  if success
    numOfPeople = jsonData.number
    $(domEl).find('#num').html numOfPeople

    $(domEl).find('#people').html ""
    for person in jsonData.people
      $(domEl).find('#people').append '<li>'+person.name+' ('+person.craft+')</li>'
