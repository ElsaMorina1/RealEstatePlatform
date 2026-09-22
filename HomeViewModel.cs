using RealEstatePlatform.ViewModels;
using System.Collections.Generic;

namespace RealEstatePlatform.Models
{
    public class HomeViewModel
    {
        public LoginViewModel Login { get; set; }

        public IEnumerable<Property> Properties { get; set; }
    }
}