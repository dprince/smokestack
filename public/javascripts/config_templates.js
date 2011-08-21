var configTemplatesTabId = 3;
var configTemplateIntervalId = setInterval(refreshConfigTemplates, 6000);

function refreshConfigTemplates() { 

    var selected = $("#tabs").tabs( "option", "selected" );
    if (selected == configTemplatesTabId) {
        reload_config_templates_table($("#config-templates-table"));
    }

}

function reload_config_templates_table(container) {

    $.ajax({
        url: '/config_templates?table_only=true',
        type: 'GET',
        success: function(data) {
            container.html(data);
            config_template_table_selectors();
        }
    });

}

function config_template_selectors() {

    $("#config-template-new-link").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#config-templates-dialog").html(
               html_snippet
           );

            $("#config-templates-dialog").dialog({
                modal: true,
                height: 500,
                width: 600,
                buttons: {
                    Create: function() { config_template_create_or_edit('POST') }
                },
                close: function(data) {
                    $(this).html("");
                    $(this).dialog('destroy');
                }
            });

        });

    });

}

function config_template_table_selectors() {

    $("#config-template-new-link").button({
                icons: {
                    primary: 'ui-icon-circle-plus'
                }
    }
    );

    $("a.config-template-destroy").button({
        icons: {
            primary: 'ui-icon-trash'
        },
        text: false
    }
    );

    $("a.config-template-edit").button({
        icons: {
            primary: 'ui-icon-wrench'
        },
        text: false
    }
    );

    $("a.config-template-show").button({
        icons: {
            primary: 'ui-icon-circle-zoomin'
        },
        text: false
    }
    );

    $(".config-template-destroy").click(function(e){

        e.preventDefault();

        if (!confirm("Delete config template?")) {
            return;
        }

        var post_data = $("#config-template-delete-form").serialize();

        $.ajax({
            url: $(this).attr("href"),
            type: 'POST',
            dataType: 'xml',
            data: post_data,
            success: function(data) {
                id=$("id", data).text();
                $("#config-template-tr-"+id).remove();
            },
            error: function(data) {
                alert('Error: Failed to destroy config template.');
            }
        });

    });

    $(".config-template-edit").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#config-templates-dialog").html(
                html_snippet
           );

            $("#config-templates-dialog").dialog({
                modal: true,
                height: 500,
                width: 600,
                buttons: {
                    Save: function() { config_template_create_or_edit('PUT'); }
                },
                close: function(data) {
                    $(this).html("");
                    $(this).dialog('destroy');
                }
            });

         });

       });

    $(".config-template-show").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#config-templates-dialog").html(
                html_snippet
           );

            $("#config-templates-dialog").dialog({
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

function config_template_create_or_edit(method) {

    var post_data = $("#config-template-form").serialize();
    $.ajax({
        url: $("#config-template-form").attr("action"),
        type: method,
        data: post_data,
        dataType: 'xml',
        success: function(data) {
            id=$("id", data).text();
            $("#config-templates-dialog").dialog('close');
            reload_config_templates_table($("#config-templates-table"));
        },
        error: function(data) {
            err_html="<ul>";
            $("error", data.responseXML).each (function() {
                err_html+="<li>"+$(this).text()+"</li>";
            });
            err_html+="</ul>";
            $("#config-template-error-messages-content").html(err_html);
            $("#config-template-error-messages").css("display", "inline");
        }
    });

}
