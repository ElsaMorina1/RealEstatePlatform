using System.ComponentModel.DataAnnotations;

namespace RealEstatePlatform.ViewModels
{
    public class RegisterViewModel
    {
        [Required(ErrorMessage = "Emri dhe Mbiemri janë të detyrueshëm.")]
        [Display(Name = "Full Name")]
        public string FullName { get; set; }

        [Required(ErrorMessage = "Email-i është i detyrueshëm.")]
        [EmailAddress(ErrorMessage = "Formati i Email-it nuk është i saktë.")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Fjalëkalimi është i detyrueshëm.")]
        [DataType(DataType.Password)]
        [StringLength(100, ErrorMessage = "Fjalëkalimi duhet të jetë së paku {2} karaktere i gjatë.", MinimumLength = 6)]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirm Password")]
        [Compare("Password", ErrorMessage = "Fjalëkalimet nuk përputhen.")]
        public string ConfirmPassword { get; set; }
    }
}
