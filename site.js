$(document).ready(function () {

   
    $("#searchInput").keyup(function () {

        let searchValue = $(this).val();

        $.ajax({
            url: "/Property/Search",
            type: "GET",
            data: {
                term: searchValue
            },
            success: function (response) {

                $("#propertyContainer").html(response);

            }
        });

    });


    $("#darkModeToggle").click(function () {

        $("body").toggleClass("dark-mode");

        localStorage.setItem(
            "darkmode",
            $("body").hasClass("dark-mode")
        );

    });

    if (localStorage.getItem("darkmode") === "true") {

        $("body").addClass("dark-mode");

    }

});


$(window).on("load", function () {
    $(".loader").fadeOut(500);
});



function deleteProperty(id) {

    Swal.fire({

        title: "Delete Property?",

        text: "This action cannot be undone.",

        icon: "warning",

        showCancelButton: true,

        confirmButtonColor: "#3085d6",

        cancelButtonColor: "#d33",

        confirmButtonText: "Delete"

    }).then((result) => {

        if (result.isConfirmed) {

            $.ajax({

                url: "/Property/Delete/" + id,

                type: "GET",

                success: function () {

                    Swal.fire(
                        "Deleted!",
                        "Property deleted successfully.",
                        "success"
                    );

                    setTimeout(() => {

                        location.reload();

                    }, 1000);

                }

            });

        }

    });

}
document.querySelectorAll(".detailsBtn").forEach(btn => {

    btn.onclick = function () {

        this.closest(".property-card")
            .classList.toggle("active");

    }

});