var jobsTabId = 1;
var jobsIntervalId = setInterval(refreshJobs, 6000);

function refreshJobs() {

    var selected = $("#tabs").tabs( "option", "selected" );
    if (selected == jobsTabId) {
        reload_jobs_table($("#jobs-table"));
    }

}

function reload_jobs_table(container) {

    $.ajax({
        url: '/jobs?table_only=true',
        type: 'GET',
        success: function(data) {
            container.html(data);
            job_table_selectors();
        }
    });

}

function job_update(job_id, post_data) {

    $.ajax({
        url: '/jobs/'+job_id,
        type: 'PUT',
        dataType: 'xml',
        data: post_data,
        success: function(data) {
            id=$("id", data).text();
        },
        error: function(data) {
            alert('Error: Failed to update job.');
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

        var post_data = $("#job-delete-form").serialize();

        $.ajax({
            url: $(this).attr("href"),
            type: 'POST',
            dataType: 'xml',
            data: post_data,
            success: function(data) {
                id=$("id", data).text();
                $("#job-tr-"+id).remove();
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
