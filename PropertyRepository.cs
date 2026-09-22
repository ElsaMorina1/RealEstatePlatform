using Microsoft.EntityFrameworkCore;
using RealEstatePlatform.Data;
using RealEstatePlatform.Models;
using RealEstatePlatform.Repository.Interfaces;

namespace RealEstatePlatform.Repository
{
    public class PropertyRepository : IPropertyRepository
    {
        private readonly ApplicationDbContext _context;

        public PropertyRepository(
            ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Property>>
            GetAllAsync()
        {
            return await _context.Properties
                .Include(x => x.Category)
                .Include(x => x.User)
                .ToListAsync();
        }

        public async Task<Property?>
            GetByIdAsync(int id)
        {
            return await _context.Properties
                .Include(x => x.Category)
                .Include(x => x.User)
                .Include(x => x.Comments)
                .FirstOrDefaultAsync(
                    x => x.Id == id);
        }
        public async Task<bool> ExistsAsync(int id)
        {
            return await _context.Properties.AnyAsync(x => x.Id == id);
        }

        public async Task AddAsync(
            Property property)
        {
            await _context.Properties
                .AddAsync(property);

            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(
            Property property)
        {
            _context.Properties
                .Update(property);

            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var property =
                await _context.Properties
                .FindAsync(id);

            if (property != null)
            {
                _context.Properties
                    .Remove(property);

                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<Property>>
            SearchAsync(string term)
        {
            return await _context.Properties
                .Where(x =>
                    x.Title.Contains(term))
                .ToListAsync();
        }

        public async Task<IEnumerable<Property>>
            FilterAsync(
            string? city,
            decimal? minPrice,
            decimal? maxPrice)
        {
            var query =
                _context.Properties
                .AsQueryable();

            if (!string.IsNullOrEmpty(city))
            {
                query =
                    query.Where(x =>
                    x.City == city);
            }

            if (minPrice.HasValue)
            {
                query =
                    query.Where(x =>
                    x.Price >= minPrice);
            }

            if (maxPrice.HasValue)
            {
                query =
                    query.Where(x =>
                    x.Price <= maxPrice);
            }

            return await query.ToListAsync();
        }
    }
}
