using Microsoft.AspNetCore.Identity;
using RealEstatePlatform.Models;

namespace RealEstatePlatform.Data
{
    public static class DbInitializer
    {
        public static async Task SeedRolesAndAdminAsync(
            IServiceProvider services)
        {
            var roleManager =
                services.GetRequiredService<
                RoleManager<IdentityRole>>();

            var userManager =
                services.GetRequiredService<
                UserManager<ApplicationUser>>();

            string[] roles =
            {
                "Admin",
                "User"
            };

            foreach (var role in roles)
            {
                if (!await roleManager.RoleExistsAsync(role))
                {
                    await roleManager.CreateAsync(
                        new IdentityRole(role));
                }
            }

            string adminEmail =
                "admin@gmail.com";

            var admin =
                await userManager
                .FindByEmailAsync(adminEmail);

            if (admin == null)
            {
                ApplicationUser user =
                    new ApplicationUser
                    {
                        FullName = "System Admin",
                        Email = adminEmail,
                        UserName = adminEmail,
                        EmailConfirmed = true
                    };

                var result =
                    await userManager.CreateAsync(
                        user,
                        "Admin123!");

                if (result.Succeeded)
                {
                    await userManager.AddToRoleAsync(
                        user,
                        "Admin");
                }
            }
        }
    }
}
