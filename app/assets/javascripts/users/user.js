//= require detect_timezone
//= require jquery.detect_timezone

$(document).ready(function(){
    $('#user_time_zone').set_timezone({format: 'city'});
    
    $('#user_avatar_attributes_kind').change(function(value) {
      var upload_input = $('#user_avatar_attributes_uri');
      
      if ($(this).val() == 'upload' ) upload_input.show();
      else upload_input.hide();
      
    });
})