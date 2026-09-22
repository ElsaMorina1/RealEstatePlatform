using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using RealEstatePlatform.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace RealEstatePlatform.Controllers.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthApiController
        : ControllerBase
    {
        private readonly UserManager<ApplicationUser>
            _userManager;

        private readonly IConfiguration
            _configuration;

        public AuthApiController(
            UserManager<ApplicationUser> userManager,
            IConfiguration configuration)
        {
            _userManager = userManager;
            _configuration = configuration;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(
            LoginModel model)
        {
            var user =
                await _userManager
                .FindByEmailAsync(
                    model.Email);

            if (user == null)
                return Unauthorized();

            bool valid =
                await _userManager
                .CheckPasswordAsync(
                    user,
                    model.Password);

            if (!valid)
                return Unauthorized();

            var roles =
                await _userManager
                .GetRolesAsync(user);

            var claims =
                new List<Claim>
                {
                    new Claim(
                        ClaimTypes.NameIdentifier,
                        user.Id),

                    new Claim(
                        ClaimTypes.Email,
                        user.Email),

                    new Claim(
                        JwtRegisteredClaimNames.Jti,
                        Guid.NewGuid().ToString())
                };

            foreach (var role in roles)
            {
                claims.Add(
                    new Claim(
                        ClaimTypes.Role,
                        role));
            }

            var key =
                new SymmetricSecurityKey(
                    Encoding.UTF8.GetBytes(
                        _configuration["Jwt:Key"]));

            var credentials =
                new SigningCredentials(
                    key,
                    SecurityAlgorithms.HmacSha256);

            var token =
                new JwtSecurityToken(
                    issuer:
                    _configuration["Jwt:Issuer"],

                    audience:
                    _configuration["Jwt:Audience"],

                    claims:
                    claims,

                    expires:
                    DateTime.Now.AddMinutes(60),

                    signingCredentials:
                    credentials);

            return Ok(new
            {
                token =
                new JwtSecurityTokenHandler()
                .WriteToken(token)
            });
        }
    }

    public class LoginModel
    {
        public string Email
        {
            get;
            set;
        }

        public string Password
        {
            get;
            set;
        }
    }
}