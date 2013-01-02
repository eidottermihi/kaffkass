/**
 * Created with JetBrains RubyMine.
 * User: ruby
 * Date: 15.11.12
 * Time: 08:35
 * To change this template use File | Settings | File Templates.
 */
(function ($) {
    $.fn.toggleDisabled = function () {
        return this.each(function () {
            this.disabled = !this.disabled;
        });
    };
})(jQuery);

$(document).ready(function () {
    $("#loadGif").hide();
    // Notification-Bar ausblenden, wenn das X angeklickt wird
    $("#notice-x").click(function () {
        $("#notice").slideUp("normal");
    });
    // Notification-Bar spätestens nach 15 Sekunden ausblenden
    setTimeout(function () {
        $("#notice").slideUp("normal");
    }, 15000);

    // Wochenfelder ausgrauen, wenn kein Konsummodell angegeben wird
    $("#no_consumption_model[type='checkbox']").click(function () {
        $("[id^=model_of_consumption]").toggleDisabled()
    });
    //Blendet das load.gif beim Aufrufen des nächsten monats der consumptions ein
    $(document).on("click", "a.loader", function () {
        $("#loadGif").show();
    });

    // Ein/Ausblende-Toggle im Userprofil
    $(".open_close").on("click", function () {
        $("#security_info").slideToggle("medium");
        $(this).toggleClass("active");
    });

});
