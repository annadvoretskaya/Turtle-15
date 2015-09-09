canvas = document.getElementById('canvas')
ctx = canvas.getContext('2d')
img = document.getElementById('turtle')
posX = 240
posY = 240
startX = 240
startY = 240
step = 20
draw = false
penColor = 'black'
penGage = 1
angle = 90
ctx.drawImage img, posX, posY, step, step
debugIndex = 0

$("#run").on "click", ->
  run()

$('#debug').on 'click', ->
  $('#run').hide()
  $('#next').show()
  $('#stop').show()
  $('#debug').hide()
  remove_turtle posX, posY
  drawCanvas()
  return


$('#stop').on 'click', ->
  $('#run').show()
  $('#debug').show()
  $('#next').hide()
  $('#stop').hide()
  remove_turtle posX, posY
  drawCanvas()
  $('.commands li').css 'background', 'white'
  debugIndex = 0
  return

$('#clear').on 'click', ->
  drawCanvas()
  $('#sortable').each ->
    $(this).children().remove()
    return
  return



$('#next').on 'click', ->
  $('.commands li').css 'background', 'white'
  item = $('.commands li')[debugIndex]
  drawItem item
  $($('.commands li')[debugIndex++]).css 'background', 'rgba(0, 255, 20, 0.5)'
  return

$('#sortable').sortable
  revert: true
  receive: (event, ui) ->
    $('.btn-sm').on 'click', (event) ->
      $(this).parent().remove()
      return
    $('.glyphicon-stop').unbind('click').on 'click', (event) ->
      event.preventDefault()
      $this = $(this)
      if $this.hasClass('white')
        $this.removeClass 'white'
        $this.addClass 'red'
      else
        $this.removeClass 'red'
        $this.addClass 'white'
      return
    return

$('.draggable').draggable
  connectToSortable: '#sortable'
  helper: 'clone'

$('ul, li').disableSelection()


remove_turtle = (x, y) ->
  img_data = ctx.createImageData(step, step)
  i = img_data.data.length
  while --i >= 0
    img_data.data[i] = 0
  ctx.putImageData img_data, x, y
  return

draw_line = (x1, y1, x2, y2) ->
  #        ctx.beginPath();
  ctx.moveTo x1 + step / 2, y1 + step / 2
  ctx.lineTo x2 + step / 2, y2 + step / 2
  ctx.lineWidth = penGage
  ctx.strokeStyle = penColor
  ctx.stroke()
  return

drawCanvas = ->
  ctx.clearRect 0, 0, canvas.width, canvas.height
  ctx.beginPath()
  posX = startX
  posY = startY
  angle = 90
  draw = false
  ctx.drawImage img, posX, posY, step, step
  return

drawItem = (item) ->
  inputValue = $($(item).children()[2]).val()
  command = $(item).data('command')
  tmpX = posX
  tmpY = posY
  switch command
    when 'up'
      remove_turtle posX, posY
      posX = posX + inputValue * step * Math.cos(angle * 2 * Math.PI / 360)
      posY = posY - inputValue * step * Math.sin(angle * 2 * Math.PI / 360)
      if draw
        draw_line tmpX, tmpY, posX, posY
        ctx.drawImage img, posX, posY, step, step
    when 'down'
      remove_turtle posX, posY
      posX = posX - inputValue * step * Math.cos(angle * 2 * Math.PI / 360)
      posY = posY + inputValue * step * Math.sin(angle * 2 * Math.PI / 360)
      if draw
        draw_line tmpX, tmpY, posX, posY
        ctx.drawImage img, posX, posY, step, step
    when 'left'
      angle += inputValue * 1
    when 'right'
      angle -= inputValue * 1
    when 'draw'
      draw = true
      penColor = $($(item).children()[2]).val()
      penGage = $($(item).children()[3]).val()
    when 's-draw'
      draw = false
    else
      break
  return

run = ->
  drawCanvas()
  $('.commands li').each (index, item) ->
    drawItem item
    return
  return