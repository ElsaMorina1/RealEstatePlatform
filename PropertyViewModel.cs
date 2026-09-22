using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace RealEstatePlatform.ViewModels
{
    public class PropertyViewModel
    {
        public int Id { get; set; }

        [Required]
        public string Title { get; set; }

        [Required]
        public string Description { get; set; }

        [Required]
        public decimal Price { get; set; }

        [Required]
        public string City { get; set; }

        [Required]
        public string AddressLine { get; set; }

        public int Bedrooms { get; set; }

        public int Bathrooms { get; set; }

        public double Area { get; set; }

        public string PropertyType { get; set; }

        public string Status { get; set; }

        public bool IsFeatured { get; set; }

        public int CategoryId { get; set; }

        public IFormFile? ImageFile { get; set; }

        public string? ExistingImage { get; set; }
    }
}

