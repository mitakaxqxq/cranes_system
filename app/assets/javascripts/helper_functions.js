$(document).ready(function() {
  var $statusField = $('#status');
  var $typeField = $('#type');
  var $loadCapacityField = $('#load_capacity');
  var $yearOfManufactureField = $('#year_of_manufacture');
  var $applicationNumberField = $('#application_number');
  var $applicationDateField = $('#application_date');
  var $registrationDateField = $('#registration_date');
  var $lastCheckDateField = $('#last_check_date');
  var $nextCheckDateField = $('#next_check_date');
  var $suspensionDateField = $('#suspension_date');
  var $scrapDateField = $('#scrap_date');
  var $userField = $('#user');
  var $userAddressField = $('#user_address');
  var $manufacturerField = $('#manufacturer');
  var $locationField = $('#location');
  var $serialNumberField = $('#serial_number');
  var $registrationNumberField = $('#registration_number');
  var $notesField = $('#notes');
  
  var formFields = [
    $statusField, $typeField, $loadCapacityField, $yearOfManufactureField, $applicationNumberField,
    $applicationDateField, $registrationDateField, $lastCheckDateField, $nextCheckDateField, 
    $suspensionDateField, $scrapDateField, $userField, $userAddressField, $manufacturerField,
    $locationField, $serialNumberField, $registrationNumberField, $notesField
  ];

  if($statusField.val() == "Бракуван")
  {
    disableFields(formFields);  
  }

  $statusField.on('change', function() {
    var dateString = new Date().toISOString().slice(0, 10);
    console.log(dateString)
    console.log($statusField.val())

    if($statusField.val() == "Бракуван")
    {
      $scrapDateField.val(dateString);
      disableFields(formFields);
      $suspensionDateField.val(null);
       
    }
    else
    {
      enableFields(formFields);
      if($statusField.val() == "Спрян от експлоатация")
      {
        $suspensionDateField.val(dateString);
        $suspensionDateField.prop('disabled', true);
        $scrapDateField.val(null);
      } 
    }  
  });
  
  
  $lastCheckDateField.on('change', function() {
    yearOfManufacture = getVal(); 
    var lastCheckDateValue = new Date($(this).val());
    var age = lastCheckDateValue.getFullYear() - yearOfManufacture;

    if(age > 10)
    {
      lastCheckDateValue.setFullYear(lastCheckDateValue.getFullYear() + 1);
      lastCheckDateValue.setMonth(lastCheckDateValue.getMonth() + 1, 1);
      lastCheckDateValue.setDate(0);
      var year = lastCheckDateValue.getFullYear();
      var month = lastCheckDateValue.getMonth() + 1;
      var day = lastCheckDateValue.getDate();
      var dateString = year + '-' + month.toString().padStart(2, '0') + '-' + day.toString().padStart(2, '0');
      $nextCheckDateField.val(dateString);
    }
    else
    {
      lastCheckDateValue.setFullYear(lastCheckDateValue.getFullYear() + 2);
      lastCheckDateValue.setMonth(lastCheckDateValue.getMonth() + 1, 1);
      lastCheckDateValue.setDate(0);
      var year = lastCheckDateValue.getFullYear();
      var month = lastCheckDateValue.getMonth() + 1;
      var day = lastCheckDateValue.getDate();
      var dateString = year + '-' + month.toString().padStart(2, '0') + '-' + day.toString().padStart(2, '0');
      $nextCheckDateField.val(dateString);
    }
    
  });
});

function getVal() {
  const val = document.querySelector('#year_of_manufacture').value;
  return val;
}

function enableFields(fields) {
  for (let i = 1; i < fields.length; i++) {
    fields[i].prop('disabled', false);
  }
}

function disableFields(fields) {
  for (let i = 1; i < fields.length; i++) {
    fields[i].prop('disabled', true);
  }
}
