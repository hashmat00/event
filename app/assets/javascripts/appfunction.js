
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


