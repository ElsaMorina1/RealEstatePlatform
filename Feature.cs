using System.ComponentModel.DataAnnotations;

namespace RealEstatePlatform.Models
{
    public class Feature
    {
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        public string? Icon { get; set; }

        public ICollection<PropertyFeature>
            PropertyFeatures
        { get; set; }
            = new List<PropertyFeature>();
    }
}