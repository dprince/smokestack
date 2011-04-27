function status_image(val) {

    var img = "";

    if (val == "Failed") {
        img = "failed";
    } else if (val == "Pending") {
        img = "pending";
    } else if (val == "Running") {
        img = "running";
    } else if (val == "Success") {
        img = "success";
    } else {
        img = "pending";
    }

    return "<img class=\"status_image\" src=\"/images/"+img+".png\"/>&nbsp;"+val;
}
