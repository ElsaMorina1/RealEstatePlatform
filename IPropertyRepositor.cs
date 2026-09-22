using RealEstatePlatform.Models;

namespace RealEstatePlatform.Repository.Interfaces
{
    public interface IPropertyRepository
    {
        Task<IEnumerable<Property>> GetAllAsync();

        Task<Property?> GetByIdAsync(int id);

        Task AddAsync(Property property);

        Task UpdateAsync(Property property);

        Task DeleteAsync(int id);

        Task<IEnumerable<Property>> SearchAsync(string term);

        Task<IEnumerable<Property>> FilterAsync(
            string? city,
            decimal? minPrice,
            decimal? maxPrice);
        Task<bool> ExistsAsync(int id);
    }
}
