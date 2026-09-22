using Microsoft.AspNetCore.Mvc;
using RealEstatePlatform.Models;
using RealEstatePlatform.Services;
using System.Diagnostics;

namespace RealEstatePlatform.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController>
            _logger;

        private readonly EmailService
            _emailService;

        public HomeController(
            ILogger<HomeController> logger,
            EmailService emailService)
        {
            _logger = logger;
            _emailService = emailService;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult Contact()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Contact(
            string name,
            string email,
            string message)
        {
            if (string.IsNullOrWhiteSpace(name) ||
               string.IsNullOrWhiteSpace(email) ||
               string.IsNullOrWhiteSpace(message))
            {
                TempData["error"] =
                    "Please fill all fields.";

                return View();
            }

            await _emailService
                .SendEmail(
                    name,
                    email,
                    message);

            TempData["success"] =
                "Message Sent Successfully";

            return RedirectToAction(
                "Contact");
        }

        [ResponseCache(
            Duration = 0,
            Location =
            ResponseCacheLocation.None,
            NoStore = true)]
        public IActionResult Error()
        {
            return View(
                new ErrorViewModel
                {
                    RequestId =
                    Activity.Current?.Id ??
                    HttpContext.TraceIdentifier
                });
        }
    }
}