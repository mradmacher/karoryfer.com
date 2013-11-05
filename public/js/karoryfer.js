$(window).load(function() {
  var height = 0;
  var img_height = 0;
  $(".thumbnail").each(function() {
    current_height = $(this).height();
    if( current_height > height ) {
      height = current_height;
    }
    current_img_height = $(this).find('img').height();
    if( current_img_height > img_height ) {
      img_height = current_img_height;
    }
  });
  $(".thumbnail").each(function() {
    $(this).height(height);
    img = $(this).find('img');
    img.css('margin-bottom', img_height - img.height());
  });
});

