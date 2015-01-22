

$(document).ready(function() {

  //check input to the vin text and enable the submit
  //once the number of characters equals 17
  $('input#vin').on("keyup change", function() {
    if ($(this).val().length === 17) {
      $('#submit-vin').removeAttr("disabled");
    }
    else {
      $('#submit-vin').attr("disabled", "disabled");
    }
  });

  //enable the make selector after choosing a year
  $('select#year').change(function() {
    $makeSelect = $('select#make');
    if (/^\d{4}$/.test($(this).val())) {
      $makeSelect.removeAttr("disabled");
      $('select#make option:gt(0)').remove();
      var year = $('select#year').val();
      $.getJSON(
        "/edmunds_makes.json?year="+year,
        function(data) {
          $.each(data, function(key,value) {
            $makeSelect.append($("<option></option>").attr("value", value).text(value));
          });
        });
    }
    else {
      $makeSelect.attr("disabled", "disabled");
    }
  });

  //enable the model selector after choosing a make
  $('select#make').change(function() {
    $modelSelect = $('select#model');
    if ($(this).val() != "") {
      $modelSelect.removeAttr("disabled");
      $('select#model option:gt(0)').remove();
      var year = $('select#year').val();
      var make = $('select#make').val();
      $.getJSON(
        "/edmunds_models.json?year="+year+"&make="+make,
        function(data) {
          $.each(data, function(key,value) {
            $modelSelect.append($("<option></option>").attr("value", value).text(value));
          });
        });
    }
    else {
      $modelSelect.attr("disabled", "disabled");
    }
  });

  //enable the trim selectro after choosing a model
  $('select#model').change(function() {
    $trimSelect = $('select#trim');
    if ($(this).val() != "") {
      $trimSelect.removeAttr("disabled");
      $('select#trim option:gt(0)').remove();
      var year = $('select#year').val();
      var make = $('select#make').val();
      var model = $('select#model').val();
      $.getJSON(
        "/edmunds_styles.json?year="+year+"&make="+make+"&model="+model,
        function(data) {
          $.each(data, function(key,value) {
            $trimSelect.append($("<option></option>").attr("value", key).text(value));
          });
        });
    }
    else {
      $trimSelect.attr("disabled", "disabled");
    }
  });

});

$(document).ajaxSuccess(function(event, xhr, settings) {
  if (settings.url.indexOf('/edmunds_vin') > -1) {
    $('#vin_info').css("display", "block")
    $('#vin_make').text(xhr.responseJSON.make);
    $('#vin_model').text(xhr.responseJSON.model);
    $('#vin_year').text(xhr.responseJSON.year);
    $('#vin_trim').text(xhr.responseJSON.trim);
  }
});
