
$(document).ready(function() {
    $('#start_date')
        .datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            minDate: new Date()
        })
        .on('changeDate', function(e) {
            var minDate = new Date(e.date.valueOf());
        		$('#end_date').datepicker('maxDate', minDate);
        });

    $('#end_date')
        .datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            minDate: new Date()
        })
        .on('changeDate', function(e) {
        		var minDate = new Date(e.date.valueOf());
            $('#start_date').datepicker('minDate', minDate);
        });
});

$(document).ready(function(){
  $('#new_event :radio').change(function(){
    var nxtTxtFld = $(this).parent().parent().find('input[type=text]');
    if ( nxtTxtFld.length ) {
        nxtTxtFld.show();
        $("input[type=text]:not(#"+nxtTxtFld.attr('id')+")").hide();
    }
    else
    {
      filterFormSubmit();
    }

  });
  $("input[type=text]").change(function(){
    filterFormSubmit();
  }
  );
  $('#new_event :checkbox').change(function(){
    filterFormSubmit();
  });

  function filterFormSubmit()
  {
    $('.manualInput').hide();
    $('#new_event').submit(); 
  }
  
  $(".price-input").ionRangeSlider({
    type: "double",
    min: 0,
    max: 100000,
    from: 100,
    to: 100,
    keyboard: true,
    step: 10,
    grid: true,
    force_edges: true,
    onFinish: function (data) {
        console.log("onFinish");
        $('#new_event').submit();
    }
  });
});



// $(document).ready(function() {
//   $('#new_event, .edit_event').formValidation({
//     framework: 'bootstrap',
//     excluded: [':disabled'],
//    	icon: {
//       valid: 'glyphicon glyphicon-ok',
//       invalid: 'glyphicon glyphicon-remove',
//       validating: 'glyphicon glyphicon-refresh'
//     },
//     fields: {
//       'event[name]': {
//         row: '.col-xs-4',
//         validators: {
//           notEmpty: {
//             message: 'The event name is required'
//           },
//           stringLength: {
//           	min: 3,
//           	max: 100,
//           	message: 'The event name must be more than 3 and less than 100 characters long'
//           }
//         }
//       }
//     }
//   });
// });



