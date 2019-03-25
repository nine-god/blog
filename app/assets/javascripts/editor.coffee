window.Editor = Backbone.View.extend
  el: '.editor-toolbar'

  events:
    "click #editor-upload-image": "browseUpload"
    "change #file_edit": "updata"
  initialize: () ->

  browseUpload:() ->
    return false

  updata:()->
    files = $('#file_edit').prop('files')
    self = @
    formData = new FormData()
    formData.append "file", files[0], 'image.png'
    $.ajax
      url: '/photos'
      type: "POST"
      data: formData
      dataType: "JSON"
      processData: false
      contentType: false
      beforeSend: ->
        #self.showUploading()
      success: (e, status, res) ->
        self.appendImageFromUpload([res.responseJSON.url])
        #self.restoreUploaderStatus()
      error: (res) ->
        console.log("上传失败")
        #App.alert("上传失败")
        #self.restoreUploaderStatus()
      complete: ->
        #self.restoreUploaderStatus()
    return false

  appendImageFromUpload : (srcs) ->
    src_merged = ""
    for src in srcs
      src_merged = "![](#{src})\n"
    @insertString(src_merged)
    return false
  insertString: (str) ->
    $target = $('textarea')
    console.log($target.val())
    start = $target[0].selectionStart
    end = $target[0].selectionEnd
    $target.val($target.val().substring(0, start) + str + $target.val().substring(end));
    $target[0].selectionStart = $target[0].selectionEnd = start + str.length
    $target.focus()