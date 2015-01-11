// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets

$(document).ready(function() {

  $('input#vin').keyup(function() {
    if ($(this).val().length === 17) {
      $('#submit-vin').removeAttr("disabled");
    }
    else {
      $('#submit-vin').attr("disabled", "disabled");
    }
  });

  $('select#year').change(function() {
    $makeSelect = $('select#make');
    if (/^\d{4}$/.test($(this).val())) {
      $makeSelect.removeAttr("disabled");
      $('select#make options:gt(0)').remove();
    }
    else {
      $makeSelect.attr("disabled", "disabled");
    }
  });

});
