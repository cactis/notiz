$uploaded = ''
$uploadedType = ''

$(document).ready ->
  initialUploader("upload_wallpapers", 'Wallpaper')
  initialUploader("upload_images", 'Image')

initialUploader = (id, type) ->
  dropbox = document.getElementById(id)
  dropbox.addEventListener "dragenter", dragEnter, false
  dropbox.addEventListener "dragexit", dragExit, false
  dropbox.addEventListener "dragover", dragOver, false
  dropbox.addEventListener "drop", drop, false

dragEnter = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()

dragExit = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()

dragOver = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()

drop = (evt) ->
  evt.stopPropagation()
  evt.preventDefault()
  files = evt.dataTransfer.files
  count = files.length
  handleFiles files, evt  if count > 0

handleFiles = (files, evt) ->
  $uploadedType = _(evt.target.className.split('_')).last()#.singularize()
  i = 0
  while i < files.length
    file = files[i]
    $uploaded = file
    if $uploadedType != 'wallpaper'
      $uploadedType = file.name.split('.').reverse()[0].toLowerCase()
    if $uploadedType == 'wallpaper'
      $uploadedType = 'wallpapers'
    else
      if _.include(["jpg", "jpeg", 'png', 'gif'], file.name.split('.').reverse()[0].toLowerCase())
        $uploadedType = 'images'
      else
        $uploadedType = 'attaches'
    reader = new FileReader()

    reader.onloadend = ((theFile) ->
      (evt) ->
        if $uploadedType == 'wallpapers'
        else
          if _.include(["jpg", "jpeg", 'png', 'gif'], theFile.name.split('.').reverse()[0].toLowerCase())
            $uploadedType = 'images'
          else
            $uploadedType = 'attaches'
        $.ajax
          url: '/' +  $uploadedType
          type: 'POST'
          data:
            asset:
              asseted_type: 'Tree'
              asseted_id: Notiz.tags.current.id
              binary_data: evt.target.result
              file_size: evt.total
              file_name: theFile.name
              content_type: theFile.type
    )(file)

    reader.readAsDataURL file
    i++
