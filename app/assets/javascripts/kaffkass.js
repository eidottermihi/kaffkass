/**
 * Created with JetBrains RubyMine.
 * User: ruby
 * Date: 15.11.12
 * Time: 08:35
 * To change this template use File | Settings | File Templates.
 */
$(document).ready(function () {
    // Notification-Bar ausblenden, wenn das X angeklickt wird
    $("#notice-x").click(function () {
        $("#notice").slideUp("normal");
    });
    // Notification-Bar spätestens nach 15 Sekunden ausblenden
    setTimeout(function () {
        $("#notice").slideUp("normal");
    }, 15000)
});
