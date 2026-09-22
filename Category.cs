using System.ComponentModel.DataAnnotations;

namespace RealEstatePlatform.Models
{
    public class Category
    {
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        public string? Icon { get; set; }

        public ICollection<Property>
            Properties
        { get; set; }
            = new List<Property>();
    }
}
