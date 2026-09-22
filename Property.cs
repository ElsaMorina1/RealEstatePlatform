using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RealEstatePlatform.Models
{
    public class Property
    {

        public int Id { get; set; }

       

        [Required]
        [StringLength(150)]
        public string Title { get; set; }

        [Required]
        [StringLength(1000)]
        public string Description { get; set; }

        [Range(1, 100000000)]
        [Column(TypeName = "decimal(18,2)")]
        public decimal Price { get; set; }

        public string? ImageUrl { get; set; }

        [Required]
        public string City { get; set; }

        [Required]
        public string AddressLine { get; set; }

        [Range(1, 20)]
        public int Bedrooms { get; set; }

        [Range(1, 20)]
        public int Bathrooms { get; set; }

        [Range(1, 50000)]
        public double Area { get; set; }

        public bool IsFeatured { get; set; }

        public DateTime CreatedAt { get; set; }
            = DateTime.Now;

        [Required]
        public string PropertyType { get; set; }

        [Required]
        public string Status { get; set; }

        public int CategoryId { get; set; }

        public Category Category { get; set; }

        public string? UserId { get; set; }

        public ApplicationUser? User { get; set; }

      
        public Address? Address { get; set; }


     





        public ICollection<PropertyFeature>
            PropertyFeatures
        { get; set; }
            = new List<PropertyFeature>();

    
        public ICollection<Comment>
            Comments
        { get; set; }
            = new List<Comment>();

       
        public ICollection<FavoriteProperty>
            FavoriteProperties
        { get; set; }
            = new List<FavoriteProperty>();
    }
}
