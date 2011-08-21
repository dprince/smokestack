function smokestack_auth () {

    var post_data = $("#auth-form").serialize();
    $.ajax({
        url: $("#auth-form").attr("action"),
        type: 'POST',
        data: post_data,
        success: function(data) {
            $("#login-dialog").dialog('close');
            location.reload();
        },
        error: function(data) {
            $("#auth-error-messages").css("display", "inline");
            err_html="<ul>";
            err_html+="<li>Authentication failed.</li>";
            err_html+="</ul>";
            $("#auth-error-messages-content").html(err_html);
        }
    });

}

function login_selectors() {

  $(".login_link").click(function(e){

    e.preventDefault();

    $.get($(this).attr("href"), function(html_snippet) {

      $("#login-dialog").html(html_snippet);

      $("#login-dialog").dialog({
        modal: true,
        height: 275,
        width: 400,
        buttons: {
          "Log In": function() { smokestack_auth(); }
        }
      });
    });
  });

  $(".logout_link").click(function(e){

    e.preventDefault();

    $.post($(this).attr("href"), function(data) {
      location.reload();
    });

  });

}
