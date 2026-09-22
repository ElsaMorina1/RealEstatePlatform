using System.ComponentModel.DataAnnotations;

namespace RealEstatePlatform.Models
{
    public class Address
    {
        public int Id { get; set; }

        [Required]
        public string City { get; set; }

        [Required]
        public string Street { get; set; }

        public int PropertyId { get; set; }

        public Property Property { get; set; }
    }
}