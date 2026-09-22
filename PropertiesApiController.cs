using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RealEstatePlatform.Models;
using RealEstatePlatform.Repository;
using RealEstatePlatform.Repository.Interfaces;

namespace RealEstatePlatform.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class PropertiesApiController : ControllerBase
    {
        private readonly IPropertyRepository _repository;

        public PropertiesApiController(
            IPropertyRepository repository)
        {
            _repository = repository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            return Ok(
                await _repository.GetAllAsync());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var property =
                await _repository.GetByIdAsync(id);

            if (property == null)
                return NotFound();

            return Ok(property);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Create(
            Property property)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            await _repository.AddAsync(property);

            return Ok(property);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(
            int id,
            Property property)
        {
            if (id != property.Id)
                return BadRequest();

            await _repository.UpdateAsync(property);

            return Ok(property);
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var exists =
                await _repository.ExistsAsync(id);

            if (!exists)
                return NotFound();

            await _repository.DeleteAsync(id);

            return Ok();
        }
    }
}


