using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RealEstatePlatform.Data;
using RealEstatePlatform.Models;

namespace RealEstatePlatform.Controllers
{
    [Authorize(Roles = "Admin")]
    public class FeatureController : Controller
    {
        private readonly ApplicationDbContext _context;

        public FeatureController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            return View(_context.Features.ToList());
        }

        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            Feature feature)
        {
            if (!ModelState.IsValid)
                return View(feature);

            _context.Features.Add(feature);

            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        public IActionResult Edit(int id)
        {
            var feature =
                _context.Features.Find(id);

            if (feature == null)
                return NotFound();

            return View(feature);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            Feature feature)
        {
            if (!ModelState.IsValid)
                return View(feature);

            _context.Features.Update(feature);

            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Delete(int id)
        {
            var feature =
                await _context.Features.FindAsync(id);

            if (feature == null)
                return NotFound();

            _context.Features.Remove(feature);

            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }
    }
}