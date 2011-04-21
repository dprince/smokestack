
function regenerate_index(container) {

	$.ajax({
		url: '/smoke_tests',
		dataType: 'json',
		type: 'GET',
		success: function(data) {
			index_html="<tr class=\"ui-widget-header\">";
			index_html+="<th>Branch name</th>";
			index_html+="<th>Description</th>";
			index_html+="<th>Revision</th>";
			index_html+="<th>Merge<br/>Trunk</th>";
			index_html+="<th></th>";
			index_html+="<th></th>";
			index_html+="<th></th>";
			index_html+="<th></th>";
			index_html+="</tr>";

			for (i=0; i<data.length; i++) {
				item=data[i].smoke_test
				index_html+="<tr id=\"smoke-test-tr-"+item.id+"\">";
				index_html+="<td>"+item.branch_url+"</td>";
				index_html+="<td>"+item.description+"</td>";
				index_html+="<td>"+item.last_revision+"</td>";
				index_html+="<td>"+item.merge_trunk+"</td>";
				index_html+="<td><a href=\"/smoke_tests/"+item.id+"\" class=\"smoke-test-show\">Show</a></td>";
				index_html+="<td><a href=\"/smoke_tests/"+item.id+"/edit\" class=\"smoke-test-edit\">Edit</a></td>";
				index_html+="<td><a href=\"/smoke_tests/"+item.id+"\" class=\"smoke-test-destroy\">Destroy</a></td>";
				index_html+="<td><a href=\"/smoke_tests/"+item.id+"\" class=\"smoke-test-run-job\">Run Job</a></td>";
				index_html+="</tr>";
			}

			container.html(index_html);
			smoke_test_selectors();
			smoke_test_table_selectors();

		},
		error: function(data) {
			alert('Failed to load smoke tests.'+data);
		}
	});

}

function smoke_test_selectors() {

    $("#smoke-test-new-link").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#smoke-tests-dialog").html(
               html_snippet
           );

            $("#smoke-tests-dialog").dialog({
                modal: true,
                height: 400,
                width: 600,
                buttons: {
                    Create: function() { smoke_test_create_or_edit('POST') }
                },
				close: function(data) {
					$("#smoke-tests-dialog").html("");
					$("#smoke-tests-dialog").dialog('destroy');
				}
            });

        });

    });

}

function smoke_test_table_selectors() {

	$("#smoke-test-new-link").button({
				icons: {
					primary: 'ui-icon-circle-plus'
				}
	}
	);

	$("a.smoke-test-run-job").button({
		icons: {
			primary: 'ui-icon-play'
		}
	}
	);

	$("a.smoke-test-destroy").button({
		icons: {
			primary: 'ui-icon-trash'
		},
		text: false
	}
	);

	$("a.smoke-test-edit").button({
		icons: {
			primary: 'ui-icon-wrench'
		},
		text: false
	}
	);

	$("a.smoke-test-show").button({
		icons: {
			primary: 'ui-icon-circle-zoomin'
		},
		text: false
	}
	);

	$(".smoke-test-destroy").click(function(e){

		e.preventDefault();

		if (!confirm("Delete smoke test?")) {
			return;
		}

		$.ajax({
			url: $(this).attr("href"),
			type: 'POST',
			dataType: 'xml',
			data: { _method: 'delete' },
			success: function(data) {
				id=$("id", data).text();
				$("#smoke-test-tr-"+id).remove();
			},
			error: function(data) {
				alert('Error: Failed to destroy smoke test.');
			}
		});

	});

    $(".smoke-test-edit").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#smoke-tests-dialog").html(
                html_snippet
           );

            $("#smoke-tests-dialog").dialog({
                modal: true,
                height: 400,
                width: 600,
                buttons: {
                    Save: function() { smoke_test_create_or_edit('PUT'); }
                },
				close: function(data) {
					$("#smoke-tests-dialog").html("");
					$("#smoke-tests-dialog").dialog('destroy');
				}
            });

         });

       });

    $(".smoke-test-show").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#smoke-tests-dialog").html(
                html_snippet
           );

            $("#smoke-tests-dialog").dialog({
                modal: true,
                height: 400,
                width: 600,
                buttons: {
                    Close: function() {
						$("#smoke-tests-dialog").dialog('close');
					}
                },
				close: function(data) {
					$("#smoke-tests-dialog").html("");
					$("#smoke-tests-dialog").dialog('destroy');
				}
            });

         });

       });

    $(".smoke-test-run-job").click(function(e){
         e.preventDefault();

         $.post($(this).attr("href"), function(html_snippet) {

			alert('Job scheduled.');

         });

       });

}

function smoke_test_create_or_edit(method) {

    var post_data = $("#smoke-test-form").serialize();
    $.ajax({
        url: $("#smoke-test-form").attr("action"),
        type: method,
        data: post_data,
        dataType: 'xml',
        success: function(data) {
            id=$("id", data).text();
            $("#smoke-tests-dialog").dialog('close');
			regenerate_index($("#smoke-tests-table"));
        },
        error: function(data) {
            err_html="<ul>";
            $("error", data.responseXML).each (function() {
                err_html+="<li>"+$(this).text()+"</li>";
            });
            err_html+="</ul>";
            $("#smoke-test-error-messages-content").html(err_html);
            $("#smoke-test-error-messages").css("display", "inline");
        }
    });

}
