using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RealEstatePlatform.Data;
using RealEstatePlatform.Models;

namespace RealEstatePlatform.Controllers
{
    [Authorize]
    public class DashboardController : Controller
    {
        private readonly ApplicationDbContext _context;

        private readonly UserManager<ApplicationUser> _userManager;

        public DashboardController(
            ApplicationDbContext context,
            UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        public async Task<IActionResult> Index()
        {
            var currentUser =
                await _userManager.GetUserAsync(User);

            ViewBag.User =
                currentUser;

            ViewBag.TotalProperties =
                await _context.Properties
                .CountAsync(x =>
                    x.UserId == currentUser.Id);

            ViewBag.Favorites =
                await _context.FavoriteProperties
                .CountAsync(x =>
                    x.UserId == currentUser.Id);

            ViewBag.Properties =
                await _context.Properties
                .Where(x =>
                    x.UserId == currentUser.Id)
                .OrderByDescending(x =>
                    x.CreatedAt)
                .ToListAsync();

            return View();
        }
    }
}