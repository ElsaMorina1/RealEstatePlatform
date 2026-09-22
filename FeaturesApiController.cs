using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RealEstatePlatform.Data;
using RealEstatePlatform.Models;

namespace RealEstatePlatform.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class FeaturesApiController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public FeaturesApiController(
            ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_context.Features.ToList());
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Create(
            Feature feature)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            _context.Features.Add(feature);

            await _context.SaveChangesAsync();

            return Ok(feature);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(
            int id,
            Feature feature)
        {
            if (id != feature.Id)
                return BadRequest();

            _context.Features.Update(feature);

            await _context.SaveChangesAsync();

            return Ok(feature);
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var feature =
                await _context.Features.FindAsync(id);

            if (feature == null)
                return NotFound();

            _context.Features.Remove(feature);

            await _context.SaveChangesAsync();

            return Ok();
        }
    }
}