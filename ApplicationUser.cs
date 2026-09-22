using Microsoft.AspNetCore.Identity;

namespace RealEstatePlatform.Models
{
    public class ApplicationUser
        : IdentityUser
    {
        public string? FullName { get; set; }

        public string? ProfileImage
        {
            get;
            set;
        }

        public ICollection<Property>
            Properties
        { get; set; }
            = new List<Property>();
    }
}