$(function() {
  
  $("#rule_kind").change(function() {
    $(".rule_kind_section").hide();
    $(".rule_kind_section input").val("");
    $(".rule_kind_section.rule_kind_" + this.value).show();
    
  })
  
});