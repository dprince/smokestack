var configTemplatesTabId = 3;
var configTemplateIntervalId = setInterval(refreshConfigTemplates, 60000);

function refreshConfigTemplates() { 

    var nav_class = $('#nav_config_templates').attr('class');
    if (nav_class == 'active') {
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

    $("#config-template-new-button").click(function(e){
         e.preventDefault();

         $.get('/config_templates/new', function(html_snippet) {

           $("#config-templates-dialog").html(
               html_snippet
           );

            $("#config-templates-dialog").dialog({
                modal: true,
                height: $(window).height()-50,
                width: $(window).width()-50,
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
                height: $(window).height()-50,
                width: $(window).width()-50,
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

    $(".config-template-nodes").click(function(e){
         e.preventDefault();

         $.get($(this).attr("href"), function(html_snippet) {

           $("#config-templates-dialog").html(
                html_snippet
           );

            $("#config-templates-dialog").dialog({
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

    $(".config-template-clone").click(function(e){

        e.preventDefault();
        var post_data = $("#config-template-clone-form").serialize();

        $.ajax({
            url: $(this).attr("href"),
            type: 'POST',
            data: post_data,
            dataType: 'xml',
            success: function(data) {
                reload_config_templates_table($("#config-templates-table"));
                alert('Config template cloned.');
            },
            error: function(data) {
                alert('Failed to clone config template.');
            }
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
            $("#config-templates-dialog").dialog('close');
            reload_config_templates_table($("#config-templates-table"));
        },
        error: function(data, textStatus, errorThrow) {
            err_html="<div class='alert alert-error' id='config-template-error-messages'><ul>";
            $("error", data.responseXML).each (function() {
                err_html+="<li>"+$(this).text()+"</li>";
            });
            err_html+="</ul></div>";
            $("#config-template-error-messages").replaceWith(err_html);
        }
    });

}
