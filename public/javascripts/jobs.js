function reload_jobs_table(container) {

	$.ajax({
		url: '/jobs?table_only=true',
		type: 'GET',
		success: function(data) {
			container.html(data);
			job_table_selectors();
		},
		error: function(data) {
			alert('Failed to load jobs.'+data);
		}
	});

}

function job_table_selectors() {

	$("a.job-destroy").button({
		icons: {
			primary: 'ui-icon-trash'
		},
		text: false
	}
	);

	$("a.job-show").button({
		icons: {
			primary: 'ui-icon-circle-zoomin'
		},
		text: false
	}
	);

	$(".job-destroy").click(function(e){

		e.preventDefault();

		if (!confirm("Delete job?")) {
			return;
		}

		$.ajax({
			url: $(this).attr("href"),
			type: 'POST',
			dataType: 'xml',
			data: { _method: 'delete' },
			success: function(data) {
				id=$("id", data).text();
				$("#job-tr-"+id).remove();
				reload_jobs_table($("#jobs-table"));
			},
			error: function(data) {
				alert('Error: Failed to destroy job.');
			}
		});

	});

    $(".job-show").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#jobs-dialog").html(
                html_snippet
           );

            $("#jobs-dialog").dialog({
                modal: true,
                height: 400,
                width: 600,
                buttons: {
                    Close: function() {
						$("#jobs-dialog").dialog('close');
					}
                },
				close: function(data) {
					$("#jobs-dialog").html("");
					$("#jobs-dialog").dialog('destroy');
				}
            });

         });

       });

}
