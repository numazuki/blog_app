document.addEventListener("turbolinks:load", function(){
  $(function(){
    var buildPreview = function(){
      $.ajax({
        url:  "/articles/markdown",
        type: "post",
        data: {body: $(".body").val()},
        dataType: "json"
      }).done(function(json){
        $("#preview").empty();
        $("#preview").append(json.body);
      })
    };
    $(".body").on("keyup", function(){
      buildPreview();
    })
    $("#article_thumbnail").on("change", function(e){
      $(".thumbnail").css("background-image",`url(${window.URL.createObjectURL(e.target.files[0])})`);
    })
    var targetIndex = 0;
    $(`.image_fields`).on("change", function(e){
      var blob = window.URL.createObjectURL(e.target.files[0]);
      targetIndex ++;
      $(this).attr("for", `article_images_attributes_${targetIndex}_image`);
      $(this).append(`<input type="file" name="article[images_attributes][${targetIndex}][image]" id="article_images_attributes_${targetIndex}_image">`);
      $(".body").focus();
      document.execCommand('insertText', false, `<img src="${blob}" alt="${e.target.files[0].name}" class="body_image">`);
      $.ajax({
        url: "/articles/set_blob",
        type: "post",
        data: {blob: blob},
        dataType: "json"
      })
      buildPreview();
    });

  })
})