var usersTabId = 2;
var usersIntervalId = setInterval(refreshUsers, 6000);

function refreshUsers() { 

    var nav_class = $('#nav_users').attr('class');
    if (nav_class == 'active') {
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
        }
    });

}

function user_selectors() {

    $("#user-new-button").click(function(e){
         e.preventDefault();

         $.get('/users/new', function(html_snippet) {

           $("#users-dialog").html(
               html_snippet
           );

            $("#users-dialog").dialog({
                modal: true,
                height: $(window).height()-50,
                width: $(window).width()-50,
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
                height: $(window).height()-50,
                width: $(window).width()-50,
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
                height: $(window).height()-50,
                width: $(window).width()-50,
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
            $("#users-dialog").dialog('close');
            reload_users_table($("#users-table"));
        },
        error: function(data, textStatus, errorThrow) {
            err_html="<div class='alert alert-error' id='user-error-messages'><ul>";
            $("error", data.responseXML).each (function() {
                err_html+="<li>"+$(this).text()+"</li>";
            });
            err_html+="</ul></div>";
            $("#user-error-messages").replaceWith(err_html);
        }
    });

}

function change_password_selector() {

    $(".user-password-link").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#change-password-dialog").html(
                html_snippet
           );

            $("#change-password-dialog").dialog({
                modal: true,
                height: $(window).height()-50,
                width: $(window).width()-50,
                buttons: {
                    Save: function() { change_password(); }
                },
                close: function(data) {
                    $(this).html("");
                    $(this).dialog('destroy');
                }
            });

         });

       });

}

function change_password() {

    var post_data = $("#user-password-form").serialize();
    $.ajax({
        url: $("#user-password-form").attr("action"),
        type: 'POST',
        data: post_data,
        dataType: 'xml',
        success: function(data) {
            id=$("id", data).text();
            $("#change-password-dialog").dialog('close');
        },
        error: function(data) {
            err_html="<div class='alert alert-error' id='user-password-error-messages'><ul>";
            $("error", data.responseXML).each (function() {
                err_html+="<li>"+$(this).text()+"</li>";
            });
            err_html+="</ul></div>";
            $("#user-password-error-messages").replaceWith(err_html);
        }
    });

}
