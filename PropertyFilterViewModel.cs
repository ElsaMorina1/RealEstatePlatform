using RealEstatePlatform.Models;

namespace RealEstatePlatform.ViewModels
{
    public class PropertyFilterViewModel
    {
        public string? Search { get; set; }

        public string? Category { get; set; }

        public string? City { get; set; }

        public decimal? MinPrice { get; set; }

        public decimal? MaxPrice { get; set; }

        public List<Property>? Properties { get; set; }
    }
}
