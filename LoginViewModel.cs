using System.ComponentModel.DataAnnotations;

namespace RealEstatePlatform.ViewModels
{
    public class LoginViewModel
    {
        [Required(ErrorMessage = "Email-i është i detyrueshëm.")]
        [EmailAddress(ErrorMessage = "Formati i Email-it nuk është i saktë.")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Fjalëkalimi është i detyrueshëm.")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

    }
}