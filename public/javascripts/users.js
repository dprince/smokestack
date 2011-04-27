var usersTabId = 2;
var usersIntervalId = setInterval(refreshUsers, 6000);

function refreshUsers() { 

	var selected = $("#tabs").tabs( "option", "selected" );
	if (selected == usersTabId) {
		reload_users_table($("#users-table"));
	} 

}

function reload_users_table(container) {

	$.ajax({
		url: '/users?table_only=true',
		type: 'GET',
		success: function(data) {
			container.html(data);
			user_table_selectors();
		},
		error: function(data) {
			alert('Failed to load users.'+data);
		}
	});

}

function user_selectors() {

    $("#user-new-link").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#users-dialog").html(
               html_snippet
           );

            $("#users-dialog").dialog({
                modal: true,
                height: 500,
                width: 600,
                buttons: {
                    Create: function() { user_create_or_edit('POST') }
                },
				close: function(data) {
					$(this).html("");
					$(this).dialog('destroy');
				}
            });

        });

    });

}

function user_table_selectors() {

	$("#user-new-link").button({
				icons: {
					primary: 'ui-icon-circle-plus'
				}
	}
	);

	$("a.user-destroy").button({
		icons: {
			primary: 'ui-icon-trash'
		},
		text: false
	}
	);

	$("a.user-edit").button({
		icons: {
			primary: 'ui-icon-wrench'
		},
		text: false
	}
	);

	$("a.user-show").button({
		icons: {
			primary: 'ui-icon-circle-zoomin'
		},
		text: false
	}
	);

	$(".user-destroy").click(function(e){

		e.preventDefault();

		if (!confirm("Delete user?")) {
			return;
		}

        var post_data = $("#user-delete-form").serialize();

		$.ajax({
			url: $(this).attr("href"),
			type: 'POST',
			dataType: 'xml',
			data: post_data,
			success: function(data) {
				id=$("id", data).text();
				$("#user-tr-"+id).remove();
			},
			error: function(data) {
				alert('Error: Failed to destroy user.');
			}
		});

	});

    $(".user-edit").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#users-dialog").html(
                html_snippet
           );

            $("#users-dialog").dialog({
                modal: true,
                height: 500,
                width: 600,
                buttons: {
                    Save: function() { user_create_or_edit('PUT'); }
                },
				close: function(data) {
					$(this).html("");
					$(this).dialog('destroy');
				}
            });

         });

       });

    $(".user-show").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#users-dialog").html(
                html_snippet
           );

            $("#users-dialog").dialog({
                modal: true,
                height: 400,
                width: 600,
                buttons: {
                    Close: function() {
						$(this).dialog('close');
					}
                },
				close: function(data) {
					$(this).html("");
					$(this).dialog('destroy');
				}
            });

         });

       });

}

function user_create_or_edit(method) {

    var post_data = $("#user-form").serialize();
    $.ajax({
        url: $("#user-form").attr("action"),
        type: method,
        data: post_data,
        dataType: 'xml',
        success: function(data) {
            id=$("id", data).text();
            $("#users-dialog").dialog('close');
			reload_users_table($("#users-table"));
        },
        error: function(data) {
            err_html="<ul>";
            $("error", data.responseXML).each (function() {
                err_html+="<li>"+$(this).text()+"</li>";
            });
            err_html+="</ul>";
            $("#user-error-messages-content").html(err_html);
            $("#user-error-messages").css("display", "inline");
        }
    });

}
