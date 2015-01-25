

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
  $('select#car_year').change(function() {
    $makeSelect = $('select#car_make');
    if (/^\d{4}$/.test($(this).val())) {
      $makeSelect.removeAttr("disabled");
      $('select#car_make option:gt(0)').remove();
      var year = $('select#car_year').val();
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
  $('select#car_make').change(function() {
    $modelSelect = $('select#car_model');
    if ($(this).val() != "") {
      $modelSelect.removeAttr("disabled");
      $('select#car_model option:gt(0)').remove();
      var year = $('select#car_year').val();
      var make = $('select#car_make').val();
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

  //enable the trim selector after choosing a model
  $('select#car_model').change(function() {
    $trimSelect = $('select#car_trim');
    if ($(this).val() != "") {
      $trimSelect.removeAttr("disabled");
      $('select#car_trim option:gt(0)').remove();
      var year = $('select#car_year').val();
      var make = $('select#car_make').val();
      var model = $('select#car_model').val();
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

  //enable the submit button after choosing a trim
  $('select#car_trim').change(function() {
    if ($(this).val() === "") {
      $('#add-to-garage').attr('disabled', 'disabled');
      $('#trim_name').val("");
    }
    else {
      $('#add-to-garage').removeAttr("disabled");
      $('#trim_name').val($('select#car_trim').find('option:selected').text());
    }
  });

});

$(document).ajaxSuccess(function(event, xhr, settings) {
  if (settings.url.indexOf('/edmunds_vin') > -1) {
    $('#vin_info').css("display", "block");

    $('#vin_make_form').val(xhr.responseJSON.make);
    $('#vin_make').text(xhr.responseJSON.make);

    $('#vin_model_form').val(xhr.responseJSON.model);
    $('#vin_model').text(xhr.responseJSON.model);

    $('#vin_year_form').val(xhr.responseJSON.year);
    $('#vin_year').text(xhr.responseJSON.year);

    $('#vin_edmunds_id_form').val(xhr.responseJSON.edmunds_id);
    $('#vin_trim_form').val(xhr.responseJSON.trim);
    $('#vin_trim').text(xhr.responseJSON.trim);
  }
});
